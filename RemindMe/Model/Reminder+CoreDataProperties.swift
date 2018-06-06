//
//  Reminder+CoreDataProperties.swift
//  RemindMe
//
//  Created by Garrett Votaw on 5/18/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        let request = NSFetchRequest<Reminder>(entityName: "Reminder")
        let sortDescriptor = NSSortDescriptor(key: "createdOn", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }

    @NSManaged public var alarm: NSDate?
    @NSManaged public var text: String
    @NSManaged public var completed: Bool
    @NSManaged public var createdOn: NSDate
    @NSManaged public var regionIdentifier: String?
    
    @nonobjc class func with(text: String, alarm: NSDate?, regionIdentifier: String?, in context: NSManagedObjectContext) -> Reminder {
        let reminder = NSEntityDescription.insertNewObject(forEntityName: "Reminder", into: context) as! Reminder
        
        reminder.createdOn = Date() as NSDate
        reminder.text = text
        reminder.alarm = alarm
        reminder.regionIdentifier = regionIdentifier
        
        return reminder
    }

}
