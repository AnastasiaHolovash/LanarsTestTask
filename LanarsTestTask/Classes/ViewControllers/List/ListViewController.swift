//
//  ViewController.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 17.03.2021.
//

import UIKit

final class ListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: - Private properties
    
    private var dataSource: TableDiffableDataSource<PersonType, Person>!
    private let coreDataManager = CoreDataManager.shared
    private var personsTableViewData = PersonsTableViewData(management: [], employees: [], accountant: [])
    
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        coreDataManager.readAll { [weak self] result in
            
            switch result {
            
            case .success(let data):
                self?.personsTableViewData.management = data.management
                self?.personsTableViewData.employees = data.employee
                self?.personsTableViewData.accountant = data.accountant
                self?.applySnapshot(animated: false)
                
            case .failure(let error):
                print(error)
            }
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
    
    // MARK: - IBActions
    
    @IBAction func editAction(_ sender: UIButton) {
        
        // Set Not Editing
        if tableView.isEditing {
            
            isEditingMode = false
            if let dataBeforeEditing = PersonsTableViewData.savedStateBeforeEditing {
                personsTableViewData = dataBeforeEditing
                applySnapshot()
            }
        } else {
            
            // Set Editing
            isEditingMode = true
            PersonsTableViewData.savedStateBeforeEditing = personsTableViewData
        }
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        
        // When Editing
        if tableView.isEditing {
            isEditingMode = false
            
            coreDataManager.updateAll(personsTableViewData: personsTableViewData.allData) { [weak self] result in
                switch result {
                
                case .success:
                    
                    self?.applySnapshot(animated: false)
                    
                case .failure(let error):
                    print(error)
                }

            }
            
//            let group = DispatchGroup()
//
//            DispatchQueue.global(qos: .background).async(group: group) {
//
//                group.enter()
//                self.coreDataManager.update(object: Management.self, with: self.personsTableViewData.management) { _ in
//                    group.leave()
//                }
//                group.enter()
//                self.coreDataManager.update(object: Employee.self, with: self.personsTableViewData.employees) { _ in
//                    group.leave()
//                }
//                group.enter()
//                self.coreDataManager.update(object: Accountant.self, with: self.personsTableViewData.accountant) { _ in
//                    group.leave()
//                }
//            }
//            group.notify(queue: DispatchQueue.main) { [weak self] in
//                self?.tableView.reloadData()
//            }
            
        } else {
            
            // When Not Editing
            let viewController = AddNewPersonViewController.create()
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - Private func
    
    private func applySnapshot(animated: Bool = true) {
        
        var newSnapshot = NSDiffableDataSourceSnapshot<PersonType, Person>()
        newSnapshot.appendSections([.management, .employee, .accountant])
        
        newSnapshot.appendItems(personsTableViewData.management, toSection: .management)
        newSnapshot.appendItems(personsTableViewData.employees, toSection: .employee)
        newSnapshot.appendItems(personsTableViewData.accountant, toSection: .accountant)
        
        dataSource.apply(newSnapshot, animatingDifferences: animated)
    }
    
}

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
        
        return tableView.isEditing ? .delete : .none
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                let section =  PersonType(rawValue: sourceIndexPath.section) ?? .employee
                row = dataSource.snapshot().numberOfItems(inSection: section) - 1
                
            }
            return IndexPath(row: row, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = AddNewPersonViewController.create(person: personsTableViewData[indexPath.section][indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }
}
