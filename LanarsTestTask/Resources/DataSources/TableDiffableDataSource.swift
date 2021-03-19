//
//  TableDiffableDataSource.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 18.03.2021.
//

import UIKit

final class TableDiffableDataSource<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable>: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> {
    
    // MARK: - Closure properties
    
    var didDeleteItem: ((ItemIdentifierType, IndexPath) -> Void)?
    var didMoveItem: ((ItemIdentifierType, IndexPath) -> Void)?
    
    // MARK: - Func
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if let model = itemIdentifier(for: sourceIndexPath) {
            didMoveItem?(model, destinationIndexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete,
           let model = itemIdentifier(for: indexPath) {
            
            var snapshot = self.snapshot()
            snapshot.deleteItems([model])
            didDeleteItem?(model, indexPath)
            
            apply(snapshot)
        }
    }
}
