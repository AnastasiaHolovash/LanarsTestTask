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
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    // MARK: - Private properties
    
    private var dataSource: TableDiffableDataSource<PersonType, Person>!
    private let coreDataManager = CoreDataManager.shared
    private var personsTableViewData = PersonsTableViewData(management: [], employees: [], accountant: [])
    
    private var isEditingMode: Bool = false {
        didSet {
            updateEditing()
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
    
    // MARK: - Setup functions
    
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
            self?.personsTableViewData.removeItem(item)
        }
        
        dataSource.didMoveItem = { [weak self] item, destinationIndexPath in
            guard let self = self else {
                return
            }
            self.personsTableViewData.removeItem(item)
            self.personsTableViewData.insertItem(item, at: destinationIndexPath)
            self.applySnapshot()
        }
    }
    
    private func updateEditing() {
        
        if isEditingMode {
            tableView.setEditing(true, animated: true)
            
            leftButton.setTitle("Cancel", for: .normal)
            
            rightButton.setImage(UIImage(), for: .normal)
            rightButton.setTitle("Done", for: .normal)
            rightButton.setTitleColor(.link, for: .normal)
            
        } else {
            tableView.setEditing(false, animated: true)
            
            leftButton.setTitle("Edit", for: .normal)
            leftButton.setTitleColor(.link, for: .normal)
            
            rightButton.setImage(.plusImage, for: .normal)
            rightButton.setTitle("", for: .normal)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func leftAction(_ sender: UIButton) {
        
        // Set Not Editing
        if tableView.isEditing {
            
            if let dataBeforeEditing = PersonsTableViewData.savedStateBeforeEditing {
                personsTableViewData = dataBeforeEditing
                applySnapshot()
            }
        } else {
            
            // Set Editing
            PersonsTableViewData.savedStateBeforeEditing = personsTableViewData
        }
        isEditingMode.toggle()
    }
    
    @IBAction func rightAction(_ sender: UIButton) {
        
        // When Editing
        if tableView.isEditing {
            
            if coreDataManager.isEdited == false {
                coreDataManager.isEdited = true
            }
            isEditingMode = false
            
            coreDataManager.updateAll(personsTableViewData: personsTableViewData.allData) { [weak self] result in
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
        
        if let model = dataSource.itemIdentifier(for: indexPath) {
            let viewController = AddNewPersonViewController.create(person: model)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
