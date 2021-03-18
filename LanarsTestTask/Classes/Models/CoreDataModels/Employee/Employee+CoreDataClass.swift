//
//  Employee+CoreDataClass.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 17.03.2021.
//
//

import Foundation
import CoreData

@objc(Employee)
public class Employee: Person {
    
    func setup(name: String, salary: Int, workplaceNumber: Int, lunchTime: Int) {
        super.setup(name: name, salary: salary)
        
        self.workplaceNumber = Int16(workplaceNumber)
        self.lunchTime = Int16(lunchTime)
    }
}