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
        
        typealias AllData = (management: [Management], employee: [Employee], accountant: [Accountant])
        
        static var savedStateBeforeEditing: Self?
        
        var management: [Management] = []
        var employees: [Employee] = []
        var accountant: [Accountant] = []
        
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
        
        var allData: AllData {
            return (management: management, employee: employees, accountant: accountant)
        }
        
    }
}
