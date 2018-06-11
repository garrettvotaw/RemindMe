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
    lazy var manager = {
        return LocationManager(locationDelegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let reminder = reminder {
            reminderTextField.text = reminder.text
            remindAtLocationSwitch.isOn = reminder.remindAtLocation
        }
        
        do {
            try manager.requestWhenInUseAuthorization()
            manager.requestLocation()
        } catch {
            print(error)
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
        do {
            try manager.requestAlwaysAuthorization()
        } catch {
            print(error)
        }
        
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true)
            
        }
        sender.cancelsTouchesInView = false
    }
    
    @IBAction func donePushed(_ sender: Any) {
        if let reminder = reminder {
            if reminder.text == reminderTextField.text || reminder.remindAtLocation == remindAtLocationSwitch.isOn {
                navigationController?.popToRootViewController(animated: true)
            } else if reminder.text != reminderTextField.text || reminder.remindAtLocation != remindAtLocationSwitch.isOn {
                reminder.text = reminderTextField.text!
                reminder.remindAtLocation = remindAtLocationSwitch.isOn
            } else {print("Issues Occured")}
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
        nextVC.manager = manager
        nextVC.regionID = reminderTextField.text
        nextVC.onArrival = onArrival
    }
 

}


extension ReminderDetailsController: LocationManagerDelegate {
    func obtainedCoordinates(_ location: CLLocation) {
        print("received location")
        region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))
    }
    
    func failedWithError(_ error: LocationError) {
        print(error)
    }
    
    func didChangeAuthorizationStatus(_ status: CLAuthorizationStatus) {
        print(status)
    }
    
    
}





