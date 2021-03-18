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
    
    func setup(name: String, salary: Int) {
        
        self.name = name
        self.salary = Int64(salary)
    }
    
    //    convenience init(name: String, salary: Int, moc: NSManagedObjectContext) {
    //
    //        let entity = NSEntityDescription.entity(forEntityName: "Person", in: moc)
    //        self.init(entity: entity!, insertInto: moc)
    //        // vars
    //        self.name = name
    //        self.salary = Int64(salary)
    //    }
}
