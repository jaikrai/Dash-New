//
//  Affirmation+CoreDataProperties.swift
//  Dash-New
//
//  Created by Jared Breedlove on 4/23/19.
//  Copyright © 2019 iMac. All rights reserved.
//
//

import Foundation
import CoreData


extension Affirmation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Affirmation> {
        return NSFetchRequest<Affirmation>(entityName: "Affirmation")
    }

    @NSManaged public var title: String?

}
