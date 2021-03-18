//
//  ViewController.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 17.03.2021.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let coreDataManager = CoreDataManager.shared
    
    private var management: [Management] = []
    private var employees: [Employee] = []
    private var accountant: [Accountant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        coreDataManager.fetchManagement { [weak self] result in
            switch result {
            case .success(let ent):
                ent.forEach { print($0) }
                self?.management = ent
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
        coreDataManager.fetchEmployee { [weak self] result in
            switch result {
            case .success(let ent):
                ent.forEach { print($0) }
                self?.employees = ent
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
        coreDataManager.fetchAccountant { [weak self] result in
            switch result {
            case .success(let ent):
                ent.forEach { print($0) }
                self?.accountant = ent
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }

    private func tableViewSetup() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: PersonTableViewCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: PersonTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        
        let viewController = AddNewPersonViewController.create()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Management"
        case 1:
            return "Employee"
        case 2:
            return "Accountant"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return management.count
        case 1:
            return employees.count
        case 2:
            return accountant.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.identifier, for: indexPath) as! PersonTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.setup(management[indexPath.row])
        case 1:
            cell.setup(employees[indexPath.row])
        case 2:
            cell.setup(accountant[indexPath.row])
        default:
            break
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    
}

