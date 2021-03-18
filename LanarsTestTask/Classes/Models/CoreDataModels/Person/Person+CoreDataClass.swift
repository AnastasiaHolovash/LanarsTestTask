//
//  Person+CoreDataClass.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 18.03.2021.
//
//

import Foundation
import CoreData

@objc(Person)
public class Person: NSManagedObject {
    
    func setup(id: Int, name: String, salary: Int) {
        
        self.id = Int16(id)
        self.name = name
        self.salary = Int64(salary)
    }
}
