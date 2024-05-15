//
//  NSMLocation+CoreDataClass.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 09-03-24.
//
//

import Foundation
import CoreData

@objc(NSMLocation)
public class NSMLocation: NSManagedObject {

}

extension NSMLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSMLocation> {
        return NSFetchRequest<NSMLocation>(entityName: "Location")
    }

    @NSManaged public var date: String?
    @NSManaged public var id: String?
    @NSManaged public var longitude: String?
    @NSManaged public var latitude: String?
    @NSManaged public var hero: NSMHero?

}

extension NSMLocation : Identifiable {

}
