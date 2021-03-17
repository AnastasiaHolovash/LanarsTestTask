//
//  AddNewPersonViewController.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 18.03.2021.
//

import UIKit

class AddNewPersonViewController: UIViewController {
    
    static func create() -> AddNewPersonViewController {
        
        let viewController = UIStoryboard.main.instantiateViewController(identifier: self.identifier) as! AddNewPersonViewController
        return viewController
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var receptionHoursTextField: UITextField!
    @IBOutlet weak var workplaceNumberTextField: UITextField!
    @IBOutlet weak var lunchTimeTextField: UITextField!
    
    @IBOutlet weak var salaryStackView: UIStackView!
    @IBOutlet weak var receptionHoursStackView: UIStackView!
    @IBOutlet weak var workplaceNumberStackView: UIStackView!
    @IBOutlet weak var lunchTimeStackView: UIStackView!
    @IBOutlet weak var accountantTypeStackView: UIStackView!
    
    private var personType: PersonType = .management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateState(animated: false)
    }
    
    @IBAction func personTypeAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            personType = .management
        case 1:
            personType = .employee
        case 2:
            personType = .accountant
        default:
            break
        }
        updateState()
    }
    
    @IBAction func accountantTypeAction(_ sender: UISegmentedControl) {
        
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
    }
    
    private func updateState(animated: Bool = true) {
        
        receptionHoursStackView.isHiddenInStackView(!personType.isHasReceptionHours, animated: animated)
        workplaceNumberStackView.isHiddenInStackView(!personType.isHasWorkplaceNumber, animated: animated)
        lunchTimeStackView.isHiddenInStackView(!personType.isHasLunchTime, animated: animated)
        accountantTypeStackView.isHiddenInStackView(!personType.isHasAccountantType, animated: animated)
    }
}

extension AddNewPersonViewController {
    
    enum PersonType {
        
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
    }
}
