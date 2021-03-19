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

    @NSManaged public var lunchTime: String
    @NSManaged public var workplaceNumber: Int16
}
