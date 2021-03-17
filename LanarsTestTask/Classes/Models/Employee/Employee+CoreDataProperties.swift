//
//  Employee+CoreDataProperties.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 17.03.2021.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var workplaceNumber: Int16
    @NSManaged public var lunchTime: Int16

}
