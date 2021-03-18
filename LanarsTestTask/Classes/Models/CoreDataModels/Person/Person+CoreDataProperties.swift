//
//  Person+CoreDataProperties.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 18.03.2021.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var salary: Int64

}

extension Person : Identifiable {

}
