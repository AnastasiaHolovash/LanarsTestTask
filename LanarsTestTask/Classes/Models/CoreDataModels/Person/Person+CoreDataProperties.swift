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

    @NSManaged public var name: String
    @NSManaged public var salary: Int64
    @NSManaged public var id: Int16
}

extension Person: Identifiable {

}
