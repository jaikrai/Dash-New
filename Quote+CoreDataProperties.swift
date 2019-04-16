//
//  Quote+CoreDataProperties.swift
//  Dash-New
//
//  Created by Jared Breedlove on 4/16/19.
//  Copyright © 2019 iMac. All rights reserved.
//
//

import Foundation
import CoreData


extension Quote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quote> {
        return NSFetchRequest<Quote>(entityName: "Quote")
    }

    @NSManaged public var fontSize: Float
    @NSManaged public var layer: Int16
    @NSManaged public var text: String?
    @NSManaged public var xpos: Float
    @NSManaged public var ypos: Float

}
