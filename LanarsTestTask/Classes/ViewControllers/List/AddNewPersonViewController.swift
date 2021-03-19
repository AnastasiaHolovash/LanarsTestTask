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
        
        let viewController = UIStoryboard.main.instantiateViewController(identifier: identifier) as! AddNewPersonViewController
        
        viewController.style = .create
        return viewController
    }
    
    /// Create VC with person
    static func create(person: Person) -> AddNewPersonViewController {
        
        let viewController = UIStoryboard.main.instantiateViewController(identifier: identifier) as! AddNewPersonViewController
        
        viewController.person = person
        viewController.style = .edit
        
        return viewController
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var personTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var receptionHoursTextField: UITextField!
    @IBOutlet weak var workplaceNumberTextField: UITextField!
    @IBOutlet weak var lunchTimeTextField: UITextField!
    @IBOutlet weak var accountantTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var lunchTimeLabel: UILabel!
    
    @IBOutlet weak var salaryStackView: UIStackView!
    @IBOutlet weak var receptionHoursStackView: UIStackView!
    @IBOutlet weak var workplaceNumberStackView: UIStackView!
    @IBOutlet weak var lunchTimeStackView: UIStackView!
    @IBOutlet weak var accountantTypeStackView: UIStackView!
    
    // MARK: - Private properties
    
    private let coreDataManager = CoreDataManager.shared
    private var personType: PersonType = .management
    private var person: Person?
    private var style: AddNewPersonViewControllerStyle = .create
    private var keyboardHandler: KeyboardEventsHandler!
    private let timeValidator = Validator(of: .time)
    
    // MARK: - Nested types
    
    enum AddNewPersonViewControllerStyle {
        
        case create
        case edit
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let person = person {
            setup(person)
        }
        
        updatePersonType(animated: false)
        keyboardSetup()
    }
    
    private func keyboardSetup() {
        
        keyboardHandler = KeyboardEventsHandler(forView: view, scroll: scrollView)
        nameTextField.delegate = self
        salaryTextField.delegate = self
        receptionHoursTextField.delegate = self
        workplaceNumberTextField.delegate = self
        lunchTimeTextField.delegate = self
        
        lunchTimeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                     for: .editingChanged)
    }
    
    // MARK: - IBActions
    
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
        updatePersonType()
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        switch style {
        
        case .create:
            createPerson()
            
        case .edit:
            editPerson()
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapOnScreen(_ sender: UITapGestureRecognizer) {
        
        UIApplication.hideKeyboard()
    }
    
    // MARK: - @objc
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        
        let lunchTimeString = lunchTimeTextField.text ?? "12:00"
        
        timeValidator.isValid(lunchTimeString.isEmpty ? "12:00" : lunchTimeString, forceExit: true) { [weak self] result in
            
            switch result {
            case .valid:
                self?.lunchTimeLabel.text = "lunch time (hh:mm)"
                self?.lunchTimeLabel.textColor = .placeholderText
                self?.saveButton.isEnabled = true
                
            case .notValid(criteria: let criteria):
                self?.lunchTimeLabel.text = criteria.errorDescription
                self?.lunchTimeLabel.textColor = .systemRed
                self?.saveButton.isEnabled = false
                
            case .notValides:
                break
            }
        }
    }
    
    // MARK: - Private functions
    
    private func updatePersonType(animated: Bool = true) {
        
        personTypeSegmentedControl.selectedSegmentIndex = personType.rawValue
        receptionHoursStackView.isHiddenInStackView(!personType.isHasReceptionHours, animated: animated)
        workplaceNumberStackView.isHiddenInStackView(!personType.isHasWorkplaceNumber, animated: animated)
        lunchTimeStackView.isHiddenInStackView(!personType.isHasLunchTime, animated: animated)
        accountantTypeStackView.isHiddenInStackView(!personType.isHasAccountantType, animated: animated)
    }
    
    private func setup(_ person: Person) {
        
        personType = PersonType.getType(from: person)
        nameTextField.text = person.name
        salaryTextField.text = String(person.salary)
        
        if let management = person as? Management {
            
            receptionHoursTextField.text = String(management.receptionHours)
        }
        
        if let employee = person as? Employee {
            
            workplaceNumberTextField.text = String(employee.workplaceNumber)
            lunchTimeTextField.text = String(employee.lunchTime)
            
            if let accountant = employee as? Accountant {
                
                accountantTypeSegmentedControl.selectedSegmentIndex = accountant.accountantType == Accountant.AccountantType.payroll.rawValue ? 0 : 1
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
        case .accountant:
            coreDataManager.delete(object: Accountant.self, id: id) { _ in
                self.createPerson(for: previousPersonType == self.personType ? id : nil)
            }
        case .employee:
            coreDataManager.delete(object: Employee.self, id: id) { _ in
                self.createPerson(for: previousPersonType == self.personType ? id : nil)
            }
        }
    }
    
    private func createPerson(for id: Int? = nil) {
        let nameString = nameTextField.text ?? "Name"
        let name = nameString.isEmpty ? "Name" : nameString
        let salary = Int(salaryTextField.text ?? "") ?? 0
        let receptionHours = Int(receptionHoursTextField.text ?? "") ?? 0
        let workplaceNumber = Int(workplaceNumberTextField.text ?? "") ?? 0
        let lunchTimeString = lunchTimeTextField.text ?? "12:00"
        let lunchTime = lunchTimeString.isEmpty ? "12:00" : lunchTimeString
        let accountantType: Accountant.AccountantType = accountantTypeSegmentedControl.selectedSegmentIndex == 0 ? .payroll : .materialsAccounting
        
        switch personType {
        
        case .management:
            
            coreDataManager.createManagement(id: id, name: name, salary: salary, receptionHours: receptionHours) { result in
                switch result {
                case .success(let ent):
                    print(ent)
                case .failure(let error):
                    print(error)
                }
            }
            
        case .employee:
            coreDataManager.createEmployee(id: id, name: name, salary: salary, workplaceNumber: workplaceNumber, lunchTime: lunchTime) { result in
                switch result {
                case .success(let ent):
                    print(ent)
                case .failure(let error):
                    print(error)
                }
            }
            
        case .accountant:
            coreDataManager.createAccountant(id: id, name: name, salary: salary, workplaceNumber: workplaceNumber, lunchTime: lunchTime, accountantType: accountantType) { result in
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

// MARK: - UITextFieldDelegate

extension AddNewPersonViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameTextField {
            salaryTextField.becomeFirstResponder()
            
        } else if textField == salaryTextField {
            _ = personType == .management
                ? receptionHoursTextField.becomeFirstResponder()
                : workplaceNumberTextField.becomeFirstResponder()
            
        } else if textField == receptionHoursTextField {
            textField.resignFirstResponder()
            
        } else if textField == workplaceNumberTextField {
            lunchTimeTextField.becomeFirstResponder()
            
        } else if textField == lunchTimeTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case salaryTextField, receptionHoursTextField, workplaceNumberTextField:
            let invalidChars = CharacterSet.decimalDigits.inverted
            
            guard string.rangeOfCharacter(from: invalidChars) == nil else {
                return false
            }
        default:
            return true
        }
        
        return true
    }
}
