//
//  Accountant+CoreDataProperties.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 17.03.2021.
//
//

import Foundation
import CoreData


extension Accountant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Accountant> {
        return NSFetchRequest<Accountant>(entityName: "Accountant")
    }

    @NSManaged public var accountantType: String

}
