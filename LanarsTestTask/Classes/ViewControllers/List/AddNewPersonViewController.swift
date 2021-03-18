//
//  AddNewPersonViewController.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 18.03.2021.
//

import UIKit

final class AddNewPersonViewController: UIViewController {
    
    // MARK: - Statics
    
    /// Create blank VC
    static func create() -> AddNewPersonViewController {
        
        let viewController = UIStoryboard.main.instantiateViewController(identifier: self.identifier) as! AddNewPersonViewController
        return viewController
    }
    
    /// Create VC with person
    static func create(personType: PersonType, person: Person) -> AddNewPersonViewController {
        
        let viewController = UIStoryboard.main.instantiateViewController(identifier: self.identifier) as! AddNewPersonViewController
        viewController.personType = personType
        viewController.person = person
        
        return viewController
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var receptionHoursTextField: UITextField!
    @IBOutlet weak var workplaceNumberTextField: UITextField!
    @IBOutlet weak var lunchTimeTextField: UITextField!
    @IBOutlet weak var accountantTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var salaryStackView: UIStackView!
    @IBOutlet weak var receptionHoursStackView: UIStackView!
    @IBOutlet weak var workplaceNumberStackView: UIStackView!
    @IBOutlet weak var lunchTimeStackView: UIStackView!
    @IBOutlet weak var accountantTypeStackView: UIStackView!
    
    let coreDataManager = CoreDataManager.shared
    private var personType: PersonType = .management
    private var person: Person?
    
    
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
        
        createPerson()
        navigationController?.popViewController(animated: true)
    }
    
    private func updateState(animated: Bool = true) {
        
        receptionHoursStackView.isHiddenInStackView(!personType.isHasReceptionHours, animated: animated)
        workplaceNumberStackView.isHiddenInStackView(!personType.isHasWorkplaceNumber, animated: animated)
        lunchTimeStackView.isHiddenInStackView(!personType.isHasLunchTime, animated: animated)
        accountantTypeStackView.isHiddenInStackView(!personType.isHasAccountantType, animated: animated)
    }
    
    func createPerson() {
        
        let name = nameTextField.text ?? "Name"
        let salary = Int(salaryTextField.text ?? "") ?? 0
        let receptionHours = Int(receptionHoursTextField.text ?? "") ?? 0
        let workplaceNumber = Int(workplaceNumberTextField.text ?? "") ?? 0
        let lunchTime = Int(lunchTimeTextField.text ?? "") ?? 0
        let accountantType = accountantTypeSegmentedControl.selectedSegmentIndex == 0 ? Accountant.AccountantType.payroll : Accountant.AccountantType.materialsAccounting
        
        switch personType {
        case .management:
            coreDataManager.createManagement(name: name, salary: salary, receptionHours: receptionHours) { result in
                switch result {
                case .success(let ent):
                    print(ent)
                case .failure(let error):
                    print(error)
                }
            }
            
        case .employee:
            coreDataManager.createEmployee(name: name, salary: salary, workplaceNumber: workplaceNumber, lunchTime: lunchTime) { result in
                switch result {
                case .success(let ent):
                    print(ent)
                case .failure(let error):
                    print(error)
                }
            }
            
        case .accountant:
            coreDataManager.createAccountant(name: name, salary: salary, workplaceNumber: workplaceNumber, lunchTime: lunchTime, accountantType: accountantType) { result in
                switch result {
                case .success(let ent):
                    print(ent)
                case .failure(let error):
                    print(error)
                }
            }
            
        }
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
