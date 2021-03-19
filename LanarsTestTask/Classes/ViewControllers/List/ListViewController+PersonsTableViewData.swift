//
//  ListViewController+PersonsTableViewData.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 19.03.2021.
//

import Foundation

// MARK: - PersonsData

extension ListViewController {
    
    struct PersonsTableViewData {
        
        // MARK: - Typealias
        
        typealias AllData = (management: [Management], employee: [Employee], accountant: [Accountant])
        
        // MARK: - Statics
        
        static var savedStateBeforeEditing: Self?
        
        // MARK: - Variables
        
        var management: [Management] = []
        var employees: [Employee] = []
        var accountant: [Accountant] = []
        var allData: AllData {
            return (management: management, employee: employees, accountant: accountant)
        }
        
        // MARK: - Subscript
        
        subscript(index: Int) -> [Person] {
            get {
                switch index {
                case 0:
                    return management
                case 1:
                    return employees
                case 2:
                    return accountant
                default:
                    return []
                }
            }
            set {
                switch index {
                case 0:
                    management = newValue as? [Management] ?? []
                case 1:
                    employees = newValue as? [Employee] ?? []
                case 2:
                    accountant = newValue as? [Accountant] ?? []
                default:
                    break
                }
            }
        }
        
        // MARK: - Funcs
        
        mutating func removeItem(_ item: Person) {
            
            switch item {
            case is Management:
                management.removeAll { $0.id == item.id }
                
            case is Accountant:
                accountant.removeAll { $0.id == item.id }
                
            case is Employee:
                employees.removeAll { $0.id == item.id }
                
            default:
                break
            }
        }
        
        mutating func insertItem(_ item: Person, at indexPath: IndexPath) {
            
            switch PersonType(rawValue: indexPath.section) {
            
            case .management:
                if let item = item as? Management {
                    management.insert(item, at: indexPath.row)
                }
            case .accountant:
                if let item = item as? Accountant {
                    accountant.insert(item, at: indexPath.row)
                }
            case .employee:
                if let item = item as? Employee {
                    employees.insert(item, at: indexPath.row)
                }
            case .none:
                break
            }
        }
    }
}
