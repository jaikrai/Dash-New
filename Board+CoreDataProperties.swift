//
//  Board+CoreDataProperties.swift
//  Dash-New
//
//  Created by Jared Breedlove on 4/14/19.
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
    @NSManaged public var id: String?
    @NSManaged public var images: NSOrderedSet?
    @NSManaged public var quotes: NSOrderedSet?

}

// MARK: Generated accessors for images
extension Board {

    @objc(insertObject:inImagesAtIndex:)
    @NSManaged public func insertIntoImages(_ value: Image, at idx: Int)

    @objc(removeObjectFromImagesAtIndex:)
    @NSManaged public func removeFromImages(at idx: Int)

    @objc(insertImages:atIndexes:)
    @NSManaged public func insertIntoImages(_ values: [Image], at indexes: NSIndexSet)

    @objc(removeImagesAtIndexes:)
    @NSManaged public func removeFromImages(at indexes: NSIndexSet)

    @objc(replaceObjectInImagesAtIndex:withObject:)
    @NSManaged public func replaceImages(at idx: Int, with value: Image)

    @objc(replaceImagesAtIndexes:withImages:)
    @NSManaged public func replaceImages(at indexes: NSIndexSet, with values: [Image])

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: Image)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: Image)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSOrderedSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSOrderedSet)

}

// MARK: Generated accessors for quotes
extension Board {

    @objc(insertObject:inQuotesAtIndex:)
    @NSManaged public func insertIntoQuotes(_ value: Quote, at idx: Int)

    @objc(removeObjectFromQuotesAtIndex:)
    @NSManaged public func removeFromQuotes(at idx: Int)

    @objc(insertQuotes:atIndexes:)
    @NSManaged public func insertIntoQuotes(_ values: [Quote], at indexes: NSIndexSet)

    @objc(removeQuotesAtIndexes:)
    @NSManaged public func removeFromQuotes(at indexes: NSIndexSet)

    @objc(replaceObjectInQuotesAtIndex:withObject:)
    @NSManaged public func replaceQuotes(at idx: Int, with value: Quote)

    @objc(replaceQuotesAtIndexes:withQuotes:)
    @NSManaged public func replaceQuotes(at indexes: NSIndexSet, with values: [Quote])

    @objc(addQuotesObject:)
    @NSManaged public func addToQuotes(_ value: Quote)

    @objc(removeQuotesObject:)
    @NSManaged public func removeFromQuotes(_ value: Quote)

    @objc(addQuotes:)
    @NSManaged public func addToQuotes(_ values: NSOrderedSet)

    @objc(removeQuotes:)
    @NSManaged public func removeFromQuotes(_ values: NSOrderedSet)

}
