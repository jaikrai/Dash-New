//
//  Board+CoreDataProperties.swift
//  Dash-New
//
//  Created by iMac on 4/8/19.
//  Copyright © 2019 iMac. All rights reserved.
//
//

import Foundation
import CoreData


extension Board {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Board> {
        return NSFetchRequest<Board>(entityName: "Board")
    }

    @NSManaged public var title: String?
    @NSManaged public var desctiption: String?
    
}
