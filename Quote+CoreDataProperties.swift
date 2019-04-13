//
//  Quote+CoreDataProperties.swift
//  Dash-New
//
//  Created by Jared Breedlove on 4/13/19.
//  Copyright © 2019 iMac. All rights reserved.
//
//

import Foundation
import CoreData


extension Quote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quote> {
        return NSFetchRequest<Quote>(entityName: "Quote")
    }

    @NSManaged public var layer: Int16
    @NSManaged public var scale: Float
    @NSManaged public var text: String?
    @NSManaged public var xpos: Int16
    @NSManaged public var ypos: Int16
    @NSManaged public var board: Board?

}
