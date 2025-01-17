//
//  PersonTableViewCell.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 17.03.2021.
//

import UIKit

final class PersonTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var receptionHoursLabel: UILabel!
    @IBOutlet weak var workplaceNumberLabel: UILabel!
    @IBOutlet weak var lunchTimeLabel: UILabel!
    @IBOutlet weak var accountantTypeLabel: UILabel!
    
    // MARK: - Public functions
    
    public func setup(person: Person) {
        
        hideAllOptionalLabels()
        nameLabel.text = person.name
        salaryLabel.setDetail(type: "Salary: ",
                              info: String(person.salary))
        
        if let management = person as? Management {
            
            receptionHoursLabel.setDetail(type: "Reception Hours: ",
                                          info: String(management.receptionHours))
        }
        
        if let employee = person as? Employee {
            
            workplaceNumberLabel.setDetail(type: "Workplace Number: ",
                                           info: String(employee.workplaceNumber))
            lunchTimeLabel.setDetail(type: "Lunch Time: ",
                                     info: String(employee.lunchTime))
            
            if let accountant = employee as? Accountant {
                
                accountantTypeLabel.setDetail(type: "Accountant Type: ",
                                              info: String(accountant.accountantType))
            }
        }
    }
    
    // MARK: - Private functions
    
    private func hideAllOptionalLabels() {
        
        receptionHoursLabel.isHidden = true
        workplaceNumberLabel.isHidden = true
        lunchTimeLabel.isHidden = true
        accountantTypeLabel.isHidden = true
    }
}
