//
//  Accountant+CoreDataClass.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 17.03.2021.
//
//

import Foundation
import CoreData

@objc(Accountant)
public class Accountant: Employee {

    func setup(name: String, salary: Int, workplaceNumber: Int, lunchTime: Int, accountantType: AccountantType) {
        super.setup(name: name, salary: salary, workplaceNumber: workplaceNumber, lunchTime: lunchTime)
        
        self.accountantType = accountantType.rawValue
    }
    
    enum AccountantType: String {
        
        case payroll
        case materialsAccounting
    }
}