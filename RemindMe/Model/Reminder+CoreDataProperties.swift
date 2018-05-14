//
//  Reminder+CoreDataProperties.swift
//  RemindMe
//
//  Created by Garrett Votaw on 5/14/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var text: String?
    @NSManaged public var alarm: NSDate?
    @NSManaged public var location: Location?

}
