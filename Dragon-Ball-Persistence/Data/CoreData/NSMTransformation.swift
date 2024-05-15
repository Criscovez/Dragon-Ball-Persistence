//
//  NSMTransformation+CoreDataClass.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 09-03-24.
//
//

import Foundation
import CoreData

@objc(NSMTransformation)
public class NSMTransformation: NSManagedObject {

}

extension NSMTransformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSMTransformation> {
        return NSFetchRequest<NSMTransformation>(entityName: "Transformation")
    }

    @NSManaged public var id: String?
    @NSManaged public var info: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: String?
    @NSManaged public var hero: NSMHero?

}

extension NSMTransformation : Identifiable {

}
