//
//  Image+CoreDataProperties.swift
//  Dash-New
//
//  Created by Jared Breedlove on 4/20/19.
//  Copyright © 2019 iMac. All rights reserved.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var height: Float
    @NSManaged public var picture: NSData?
    @NSManaged public var width: Float
    @NSManaged public var xpos: Float
    @NSManaged public var ypos: Float
    @NSManaged public var board: Board?

}
