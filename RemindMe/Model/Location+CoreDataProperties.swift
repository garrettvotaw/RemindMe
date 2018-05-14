//
//  Location+CoreDataProperties.swift
//  RemindMe
//
//  Created by Garrett Votaw on 5/14/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var longitude: Double
    @NSManaged public var lattitude: Double
    @NSManaged public var reminder: Reminder?

}
