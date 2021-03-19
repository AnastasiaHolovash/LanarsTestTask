//
//  PersonType.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 19.03.2021.
//

import Foundation

enum PersonType: Int {
    
    case management
    case employee
    case accountant
    
    var isHasReceptionHours: Bool {
        switch self {
        case .management:
            return true
        default:
            return false
        }
    }
    
    var isHasWorkplaceNumber: Bool {
        switch self {
        case .employee, .accountant:
            return true
        default:
            return false
        }
    }
    
    var isHasLunchTime: Bool {
        switch self {
        case .employee, .accountant:
            return true
        default:
            return false
        }
    }
    
    var isHasAccountantType: Bool {
        switch self {
        case .accountant:
            return true
        default:
            return false
        }
    }
    
    static func getType(from person: Person) -> Self {
        switch person {
        case is Management:
            return .management
        case is Accountant:
            return .accountant
        case is Employee:
            return .employee
        default:
            return .employee
        }
    }
    
    var personSelf: Person.Type {
        switch self {
        case .accountant:
            return Accountant.self
        case .management:
            return Management.self
        case .employee:
            return Employee.self
        }
    }
}
