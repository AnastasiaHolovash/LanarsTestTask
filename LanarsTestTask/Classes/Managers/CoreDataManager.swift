//
//  CoreDataManager.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 17.03.2021.
//

import CoreData
import Foundation

class CoreDataManager {
    
    private let modelName = "LanarsTestTask"
    private let persistentContainer: NSPersistentContainer
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Singleton
    static let instance = CoreDataManager()
    
    private init() {
        
        let fileURL = FileManager.libraryURL().appendingPathComponent(modelName).appendingPathExtension("sqlite")
        let container = NSPersistentContainer(name: modelName)
        let fileDescription = NSPersistentStoreDescription(url: fileURL)
        container.persistentStoreDescriptions = [fileDescription]
        
        persistentContainer = container
        setup()
    }


    private func setup() {
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        }
    }

}
