//
//  PersonTableViewCell.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 17.03.2021.
//

import UIKit

final class PersonTableViewCell: UITableViewCell {

    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var receptionHoursLabel: UILabel!
    @IBOutlet weak var workplaceNumberLabel: UILabel!
    @IBOutlet weak var lunchTimeLabel: UILabel!
    @IBOutlet weak var accountantType: UILabel!
    
    public func setup(_ person: Management) {
        
        nameLabel.text = person.name
        salaryLabel.text = String(person.salary)
        receptionHoursLabel.text = String(person.receptionHours)
        
        hideAllOptionalLabels()
        receptionHoursLabel.isHidden = false
    }
    
    public func setup(_ person: Employee) {
        
        hideAllOptionalLabels()
        nameLabel.text = person.name
        salaryLabel.text = String(person.salary)
        workplaceNumberLabel.text = String(person.workplaceNumber)
        lunchTimeLabel.text = String(person.lunchTime)
        
        hideAllOptionalLabels()
        workplaceNumberLabel.isHidden = false
        lunchTimeLabel.isHidden = false
    }
    
    public func setup(_ person: Accountant) {
        
        nameLabel.text = person.name
        salaryLabel.text = String(person.salary)
        workplaceNumberLabel.text = String(person.workplaceNumber)
        lunchTimeLabel.text = String(person.lunchTime)
        accountantType.text = String(person.accountantType)
        
        hideAllOptionalLabels()
        workplaceNumberLabel.isHidden = false
        lunchTimeLabel.isHidden = false
        accountantType.isHidden = false
    }
    
//    public func setup(person: Person) {
//
//        hideAllOptionalLabels()
//        nameLabel.text = person.name
//        salaryLabel.text = String(person.salary)
//
//        if let management = person as? Management {
//
//            receptionHoursLabel.text = String(management.receptionHours)
//            receptionHoursLabel.isHidden = false
//        }
//
//        if let employee = person as? Employee {
//
//            workplaceNumberLabel.text = String(employee.workplaceNumber)
//            lunchTimeLabel.text = String(employee.lunchTime)
//            workplaceNumberLabel.isHidden = false
//            lunchTimeLabel.isHidden = false
//
//            if let accountant = employee as? Accountant {
//
//                accountantType.text = String(accountant.accountantType)
//                accountantType.isHidden = false
//            }
//        }
//    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
    
    private func hideAllOptionalLabels() {
        
        receptionHoursLabel.isHidden = true
        workplaceNumberLabel.isHidden = true
        lunchTimeLabel.isHidden = true
        accountantType.isHidden = true
    }
}
