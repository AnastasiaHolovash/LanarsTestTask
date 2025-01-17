//
//  Management+CoreDataClass.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 17.03.2021.
//
//

import Foundation
import CoreData

@objc(Management)
public class Management: Person {

    func setup(id: Int, name: String, salary: Int, receptionHours: Int) {
        super.setup(id: id, name: name, salary: salary)
        
        self.receptionHours = Int16(receptionHours)
    }
}
