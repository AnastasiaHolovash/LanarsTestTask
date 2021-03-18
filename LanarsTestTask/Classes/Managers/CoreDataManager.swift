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
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Singleton
    static let shared = CoreDataManager()
    
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
    
    // MARK: - Create
    
    @discardableResult
    private func insertObject<ManagedObject: NSManagedObject>(type: ManagedObject.Type,
                                                              managedObjectContext: NSManagedObjectContext,
                                                              configuration: (ManagedObject) -> Void) throws -> ManagedObject {
        
        let entity = ManagedObject.entity()
        let object: ManagedObject = ManagedObject(entity: entity, insertInto: managedObjectContext)
        
        configuration(object)
        return object
    }
    
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: viewContext)!
    }
    
    // MARK: Management
    
    func createManagement(id: Int? = nil, name: String, salary: Int, receptionHours: Int, completion: @escaping (Result<Management, Error>) -> Void) {
        
        let context = persistentContainer.newBackgroundContext()
        let request: NSFetchRequest<Management> = Management.fetchRequest()
        request.includesSubentities = false
        
        do {
            let newId = id != nil ? id! : try context.count(for: request)
            let employee = try insertObject(type: Management.self, managedObjectContext: context) { employee in
                
                employee.setup(id: newId, name: name, salary: salary, receptionHours: receptionHours)
            }
            try context.save()
            completion(.success(employee))
        } catch {
            debugPrint(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    // MARK: Employee
    
    func createEmployee(name: String, salary: Int, workplaceNumber: Int, lunchTime: Int, completion: @escaping (Result<Employee, Error>) -> Void) {
        
        let context = persistentContainer.newBackgroundContext()
        let request: NSFetchRequest<Employee> = Employee.fetchRequest()
        request.includesSubentities = false
        do {
            let id = try context.count(for: request)
            let employee = try insertObject(type: Employee.self, managedObjectContext: context) { employee in
                
                employee.setup(id: id, name: name, salary: salary, workplaceNumber: workplaceNumber, lunchTime: lunchTime)
            }
            try context.save()
            completion(.success(employee))
        } catch {
            debugPrint(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    // MARK: Accountant
    
    func createAccountant(name: String, salary: Int, workplaceNumber: Int, lunchTime: Int, accountantType: Accountant.AccountantType, completion:@escaping (Result<Accountant, Error>) -> Void) {
        
        let context = persistentContainer.newBackgroundContext()
        let request: NSFetchRequest<Accountant> = Accountant.fetchRequest()
        request.includesSubentities = false
        do {
            let id = try context.count(for: request)
            let employee = try insertObject(type: Accountant.self, managedObjectContext: context) { employee in
                
                employee.setup(id: id, name: name, salary: salary, workplaceNumber: workplaceNumber, lunchTime: lunchTime, accountantType: accountantType)
                
            }
            
            try context.save()
            completion(.success(employee))
        } catch {
            debugPrint(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    // MARK: - Fetch
    
    func fetch<Object: NSManagedObject>(object: Object.Type, completion:@escaping (Result<[Object], Error>) -> Void) {
        
        let request: NSFetchRequest<Object> = Object.fetchRequest()
        let sort = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sort]
        request.includesSubentities = false
        
        do {
            let employees = try viewContext.fetch(request)
            completion(.success(employees))
        } catch {
            debugPrint(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    // MARK: - Update
    
    func update<Object: NSManagedObject>(object: Object.Type, with data: [Object], completion: @escaping (Result<[Object], Error>) -> Void) {
        
        let context = persistentContainer.newBackgroundContext()
        let request: NSFetchRequest<Object> = Object.fetchRequest()
        
        do {
            try context.fetch(request).forEach { context.delete($0) }
            
            for index in 0..<data.count {
                
                let newObject = data[index]
                try insertObject(type: Object.self, managedObjectContext: context) { object in
                    
                    if let management = object as? Management, let newManagement = newObject as? Management  {
                        
                        management.setup(id: index,
                                        name: newManagement.name,
                                        salary: Int(newManagement.salary))
                        
                    } else if let employee = object as? Employee, let newEmployee = newObject as? Employee {
                        
                        employee.setup(id: index,
                                       name: newEmployee.name,
                                       salary: Int(newEmployee.salary),
                                       workplaceNumber: Int(newEmployee.workplaceNumber),
                                       lunchTime: Int(newEmployee.lunchTime))
                        
                    } else if let accountant = object as? Accountant, let newAccountant = newObject as? Accountant {
                        
                        accountant.setup(id: index,
                                         name: newAccountant.name,
                                         salary: Int(newAccountant.salary),
                                         workplaceNumber: Int(newAccountant.salary),
                                         lunchTime: Int(newAccountant.salary),
                                         accountantType: Accountant.AccountantType(rawValue: newAccountant.accountantType) ?? .payroll)
                    }
                }
            }
            
            try context.save()
        } catch {
            print("Save Failed: \(error)")
        }
    }
    
    // MARK: Management
    
    func delete<Object: NSManagedObject>(object: Object.Type, id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let context = persistentContainer.newBackgroundContext()
        
        let request: NSFetchRequest<Object> = Object.fetchRequest()
        request.predicate = NSPredicate(format: "id == \(id)")
        request.includesSubentities = false
        
        do {
            try context.fetch(request).forEach { context.delete($0) }
            try context.save()
            completion(.success(()))
        } catch {
            debugPrint(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
}
