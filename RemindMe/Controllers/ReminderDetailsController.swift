//
//  ReminderDetailsController.swift
//  RemindMe
//
//  Created by Garrett Votaw on 5/10/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation
import UserNotifications

class ReminderDetailsController: UITableViewController, UITextFieldDelegate {

   
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reminderTextField: UITextField!
    @IBOutlet weak var remindAtLocationSwitch: UISwitch!
    var context: NSManagedObjectContext!
    var reminder: Reminder?
    var region: MKCoordinateRegion?
    var monitoredRegion: CLRegion?
    var onArrival: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let reminder = reminder {
            reminderTextField.text = reminder.text
            remindAtLocationSwitch.isOn = reminder.remindAtLocation
        }
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    @IBAction func remindAtLocationSwitched(_ sender: Any) {
        guard let reminder = reminder else {return}
        reminder.remindAtLocation = true
        
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true)
            
        }
        sender.cancelsTouchesInView = false
    }
    
    @IBAction func donePushed(_ sender: Any) {
        if let reminder = reminder {
            if reminder.text == reminderTextField.text && reminder.remindAtLocation == remindAtLocationSwitch.isOn && reminder.regionIdentifier == monitoredRegion?.identifier {
                navigationController?.popToRootViewController(animated: true)
            } else if reminder.text != reminderTextField.text || reminder.remindAtLocation != remindAtLocationSwitch.isOn {
                reminder.text = reminderTextField.text!
                reminder.remindAtLocation = remindAtLocationSwitch.isOn
                do {
                    try context.saveChanges()
                } catch {
                    print(error)
                }
                navigationController?.popToRootViewController(animated: true)
            } else {
                print("Issues Occured")
                navigationController?.popToRootViewController(animated: true)
            }
        } else {
            print("Reminder did not exist")
            guard let text = reminderTextField.text, !text.isEmpty else {return}
            let _ = Reminder.with(text: text, alarm: nil, regionIdentifier: monitoredRegion?.identifier, in: context, remindAtLocation: remindAtLocationSwitch.isOn)
            do {
                try context.saveChanges()
            } catch {
                print(error)
            }
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func changedOnEntry(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            onArrival = true
        } else {
            onArrival = false
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextVC = segue.destination as? LocationController else {return}
        nextVC.region = region
        nextVC.regionID = reminderTextField.text
        nextVC.onArrival = onArrival
    }
 

}





