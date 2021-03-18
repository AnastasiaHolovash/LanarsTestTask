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
        
        viewController.style = .create
        return viewController
    }
    
    /// Create VC with person
    static func create(person: Person) -> AddNewPersonViewController {
        
        let viewController = UIStoryboard.main.instantiateViewController(identifier: self.identifier) as! AddNewPersonViewController

        viewController.person = person
        viewController.style = .edit
        
        return viewController
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var personTypeSegmentedControl: UISegmentedControl!
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
    private var style: AddNewPersonViewControllerStyle = .create
    
    enum AddNewPersonViewControllerStyle {
        
        case create
        case edit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let person = person {
            setup(person)
        }
        
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
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        switch style {
        case .create:
            createPerson()
            navigationController?.popViewController(animated: true)
        case .edit:
            
            editPerson()
//            let id = Int(person?.id ?? 0)
//
//            coreDataManager.delete(object: Management.self, id: id) { _ in
//                self.createPerson(for: id)
                self.navigationController?.popViewController(animated: true)
//            }
        }
    }
    
    private func updateState(animated: Bool = true) {
        
        personTypeSegmentedControl.selectedSegmentIndex = personType.rawValue
        receptionHoursStackView.isHiddenInStackView(!personType.isHasReceptionHours, animated: animated)
        workplaceNumberStackView.isHiddenInStackView(!personType.isHasWorkplaceNumber, animated: animated)
        lunchTimeStackView.isHiddenInStackView(!personType.isHasLunchTime, animated: animated)
        accountantTypeStackView.isHiddenInStackView(!personType.isHasAccountantType, animated: animated)
    }
    
    private func setup(_ person: Person) {
        
        nameTextField.text = person.name
        salaryTextField.text = String(person.salary)

        if let management = person as? Management {

            receptionHoursTextField.text = String(management.receptionHours)
            personType = .management
        }

        if let employee = person as? Employee {

            workplaceNumberTextField.text = String(employee.workplaceNumber)
            lunchTimeTextField.text = String(employee.lunchTime)
            
            personType = .employee

            if let accountant = employee as? Accountant {
                
                accountantTypeSegmentedControl.selectedSegmentIndex = accountant.accountantType == Accountant.AccountantType.payroll.rawValue ? 0 : 1
                
                personType = .accountant
            }
        }
    }
    
    private func editPerson() {
        
        guard let person = person else {
            return
        }
        let id = Int(person.id)
        let previousPersonType = PersonType.getType(from: person)
        
        switch previousPersonType {
        
        case .management:
            
            coreDataManager.delete(object: Management.self, id: id) { _ in
                self.createPerson(for: previousPersonType == self.personType ? id : nil)
            }
        case .employee:
            coreDataManager.delete(object: Employee.self, id: id) { _ in
                self.createPerson(for: previousPersonType == self.personType ? id : nil)
            }
        case .accountant:
            coreDataManager.delete(object: Accountant.self, id: id) { _ in
                self.createPerson(for: previousPersonType == self.personType ? id : nil)
            }
        }
    }
    
    private func createPerson(for id: Int? = nil) {
        
        let name = nameTextField.text ?? "Name"
        let salary = Int(salaryTextField.text ?? "") ?? 0
        let receptionHours = Int(receptionHoursTextField.text ?? "") ?? 0
        let workplaceNumber = Int(workplaceNumberTextField.text ?? "") ?? 0
        let lunchTime = Int(lunchTimeTextField.text ?? "") ?? 0
        let accountantType = accountantTypeSegmentedControl.selectedSegmentIndex == 0 ? Accountant.AccountantType.payroll : Accountant.AccountantType.materialsAccounting
        
        switch personType {
        
        case .management:
            
            coreDataManager.createManagement(id: id,name: name, salary: salary, receptionHours: receptionHours) { result in
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
}


