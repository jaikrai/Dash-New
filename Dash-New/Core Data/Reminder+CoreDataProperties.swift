//
//  Reminder+CoreDataProperties.swift
//  Dash-New
//
//  Created by Jared Breedlove on 4/23/19.
//  Copyright © 2019 iMac. All rights reserved.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var hour: Int32
    @NSManaged public var minute: Int32

}
