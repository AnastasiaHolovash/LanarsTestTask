//
//  Management+CoreDataProperties.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 17.03.2021.
//
//

import Foundation
import CoreData


extension Management {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Management> {
        return NSFetchRequest<Management>(entityName: "Management")
    }

    @NSManaged public var receptionHours: Int16

}
