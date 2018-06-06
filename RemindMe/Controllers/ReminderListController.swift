//
//  ReminderListController.swift
//  RemindMe
//
//  Created by Garrett Votaw on 5/10/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import CoreLocation

class ReminderListController: UITableViewController {
    
    let context = CoreDataStack().managedObjectContext
    var indexPathOfAccessoryTap: IndexPath?
    lazy var fetchedResultsController: NSFetchedResultsController<Reminder> = {
        let request: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }()
    let notificationCenter = UNUserNotificationCenter.current()
    let locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 65
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error fetching the Entries!")
        }
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { didGrantAccess, error in
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {return 0}
        return section.numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderCell

        let reminder = fetchedResultsController.object(at: indexPath)
        
        cell.reminderTitleLabel.text = reminder.text
        
        if reminder.completed {
            cell.bubbleImageView.image = #imageLiteral(resourceName: "FilledCircle")
        } else {
            cell.bubbleImageView.image = #imageLiteral(resourceName: "UnfilledCircle")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ReminderCell
        let reminder = fetchedResultsController.object(at: indexPath)
        if cell.bubbleImageView.image == #imageLiteral(resourceName: "FilledCircle") {
            cell.bubbleImageView.image = #imageLiteral(resourceName: "UnfilledCircle")
            reminder.completed = false
        } else {
            cell.bubbleImageView.image = #imageLiteral(resourceName: "FilledCircle")
            reminder.completed = true
        }
        do {
           try context.saveChanges()
        } catch {
            print(error)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let reminder = fetchedResultsController.object(at: indexPath)
            let regions = locationManager.monitoredRegions
            if let reminderRegionID = reminder.regionIdentifier {
                for aregion in regions {
                    if aregion.identifier == reminderRegionID {
                        locationManager.stopMonitoring(for: aregion)
                    }
                }
            }
            context.delete(reminder)
            do {
                try context.saveChanges()
            } catch {
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        indexPathOfAccessoryTap = indexPath
        performSegue(withIdentifier: "Details", sender: nil)
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nextVC = segue.destination as? ReminderDetailsController else {print("failed"); return}
        nextVC.context = self.context
        
        if segue.identifier == "Details" {
            guard let index = indexPathOfAccessoryTap else {return}
            let reminder = fetchedResultsController.object(at: index)
            nextVC.reminder = reminder
        }
        
    }
    

}



extension ReminderListController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move, .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}















