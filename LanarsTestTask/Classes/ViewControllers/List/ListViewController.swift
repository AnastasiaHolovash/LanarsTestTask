//
//  ViewController.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 17.03.2021.
//

import UIKit

final class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    private var dataSource: TableDiffableDataSource<Section, Person>!
    
    let coreDataManager = CoreDataManager.shared
    
    private var personsTableViewData = PersonsData(management: [], employees: [], accountant: [])
    
    private var isEditingMode: Bool = false {
        
        didSet {
            if isEditingMode {
                tableView.setEditing(true, animated: true);
                
                editButton.setTitle("Cancel", for: .normal)
                editButton.setTitleColor(.systemRed, for: .normal)
                
                addButton.setImage(UIImage(), for: .normal)
                addButton.setTitle("Done", for: .normal)
                addButton.setTitleColor(.systemOrange, for: .normal)
                
            } else {
                tableView.setEditing(false, animated: true);
                
                editButton.setTitle("Edit", for: .normal)
                editButton.setTitleColor(.systemOrange, for: .normal)
                
                addButton.setImage(.plusImage, for: .normal)
                addButton.setTitle("", for: .normal)
            }
        }
    }
    
    enum Section: Int {
        
        case management
        case employee
        case accountant
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let group = DispatchGroup()
        
        DispatchQueue.global(qos: .background).async(group: group) { [weak self] in
            
            guard let self = self else {
                return
            }
            group.enter()
            self.coreDataManager.fetch(object: Management.self) { [weak self] result in
                switch result {
                case .success(let ent):
                    ent.forEach { print($0) }
                    self?.personsTableViewData.management = ent
                    
                case .failure(let error):
                    print(error)
                }
                group.leave()
            }
            
            group.enter()
            self.coreDataManager.fetch(object: Employee.self) { [weak self] result in
                switch result {
                case .success(let ent):
                    ent.forEach { print($0) }
                    self?.personsTableViewData.employees = ent
                    
                case .failure(let error):
                    print(error)
                }
                group.leave()
            }
            
            group.enter()
            self.coreDataManager.fetch(object: Accountant.self) { [weak self] result in
                switch result {
                case .success(let ent):
                    ent.forEach { print($0) }
                    self?.personsTableViewData.accountant = ent
                case .failure(let error):
                    print(error)
                }
                group.leave()
            }
            
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            self?.applySnapshot(animated: false)
        }
    }
    
    private func tableViewSetup() {
        
        tableView.delegate = self
        tableView.register(UINib(nibName: PersonTableViewCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: PersonTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        
        dataSource = TableDiffableDataSource(tableView: tableView) { tableView, indexPath, item  in
            let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.identifier, for: indexPath) as! PersonTableViewCell
            
            cell.setup(person: item)
            return cell
        }
        
        dataSource.didDeleteItem = { [weak self] item, indexPath in
            
            self?.personsTableViewData[indexPath.section].remove(at: indexPath.row)
        }
        
        dataSource.didMoveItem = { [weak self] sourceIndexPath, destinationIndexPath in
            guard let self = self else {
                return
            }
            let sourceItem = self.personsTableViewData[sourceIndexPath.section].remove(at: sourceIndexPath.row)
            self.personsTableViewData[destinationIndexPath.section].insert(sourceItem, at: destinationIndexPath.row)
            self.applySnapshot()
        }
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        
        // Set Not Editing
        if tableView.isEditing {
            
            isEditingMode = false
            if let dataBeforeEditing = PersonsData.savedStateBeforeEditing {
                personsTableViewData = dataBeforeEditing
                //                tableView.reloadData()
                applySnapshot()
                
            }
            
        } else {
            
            // Set Editing
            isEditingMode = true
            PersonsData.savedStateBeforeEditing = personsTableViewData
        }
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        
        // When Editing
        if tableView.isEditing {
            isEditingMode = false
            
            let group = DispatchGroup()
            
            DispatchQueue.global(qos: .background).async(group: group) { [weak self] in
                
                guard let self = self else {
                    return
                }
                
                group.enter()
                self.coreDataManager.update(object: Management.self, with: self.personsTableViewData.management) { _ in
                    group.leave()
                }
                group.enter()
                self.coreDataManager.update(object: Employee.self, with: self.personsTableViewData.employees) { _ in
                    group.leave()
                }
                group.enter()
                self.coreDataManager.update(object: Accountant.self, with: self.personsTableViewData.accountant) { _ in
                    group.leave()
                }
            }
            group.notify(queue: DispatchQueue.main) { [weak self] in
                self?.tableView.reloadData()
            }
            
        } else {
            
            // When Not Editing
            let viewController = AddNewPersonViewController.create()
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func applySnapshot(animated: Bool = true) {
        
        var newSnapshot = NSDiffableDataSourceSnapshot<Section, Person>()
        newSnapshot.appendSections([.management, .employee, .accountant])
        
        newSnapshot.appendItems(personsTableViewData.management, toSection: .management)
        newSnapshot.appendItems(personsTableViewData.employees, toSection: .employee)
        newSnapshot.appendItems(personsTableViewData.accountant, toSection: .accountant)
        
        dataSource.apply(newSnapshot, animatingDifferences: animated)
    }
    
}

//// MARK: - UITableViewDataSource
//
//extension ListViewController: UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        switch section {
//        case 0:
//            return "Management"
//        case 1:
//            return "Employee"
//        case 2:
//            return "Accountant"
//        default:
//            return nil
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return personsTableViewData[section].count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.identifier, for: indexPath) as! PersonTableViewCell
//
//        cell.setup(person: personsTableViewData[indexPath.section][indexPath.row])
//        return cell
//    }
//}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionOb = dataSource.snapshot().sectionIdentifiers[section]
        let label = UILabel()
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.text = "\(sectionOb)".capitalized
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            personsTableViewData[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    //
    //        return true
    //    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                //                row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
                let section =  Section(rawValue: sourceIndexPath.section) ?? .employee
                row = dataSource.snapshot().numberOfItems(inSection: section) - 1
                
            }
            return IndexPath(row: row, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let sourceItem = personsTableViewData[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        personsTableViewData[destinationIndexPath.section].insert(sourceItem, at: destinationIndexPath.row)
        
    }
}

// MARK: - PersonsData

extension ListViewController {
    
    struct PersonsData {
        
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
        
    }
    
    func compare(personsBefore: [Person], personsAfter: [Person]) -> [(Int, Int)] {
        
        var result: [(Int, Int)] = []
        
        for oldIndex in 0..<personsBefore.count {
            let oldPerson = personsBefore[oldIndex]
            if let newIndex: Int = personsAfter.firstIndex(of: oldPerson) {
                result.append((oldIndex, newIndex))
                
            } else {
                result.append((oldIndex, -1))
            }
        }
        return result
    }
}
