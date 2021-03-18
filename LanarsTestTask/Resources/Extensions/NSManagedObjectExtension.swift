//
//  NSManagedObjectExtension.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 18.03.2021.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    @nonobjc public class func fetchRequest<Object: NSManagedObject>() -> NSFetchRequest<Object> {
        return NSFetchRequest<Object>(entityName: String(describing: Object.self))
    }
}
