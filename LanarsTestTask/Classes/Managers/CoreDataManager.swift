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
    
    func createManagement(name: String, salary: Int, receptionHours: Int, completion:@escaping (Result<Management, Error>) -> Void) {
        
        let context = persistentContainer.newBackgroundContext()
        do {
            let employee = try insertObject(type: Management.self, managedObjectContext: context) { employee in
                
                employee.name = name
                employee.salary = Int64(salary)
                employee.receptionHours = Int16(receptionHours)
            }
            try context.save()
            completion(.success(employee))
        } catch {
            debugPrint(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    func fetchManagement(completion:@escaping (Result<[Management], Error>) -> Void) {

        let request: NSFetchRequest<Management> = Management.fetchRequest()

        do {
            let employees = try viewContext.fetch(request)
            completion(.success(employees))
        } catch {
            debugPrint(error.localizedDescription)
            completion(.failure(error))
        }

    }

    
    // MARK: Employee
    
    func createEmployee(name: String, salary: Int, workplaceNumber: Int, lunchTime: Int, completion:@escaping (Result<Employee, Error>) -> Void) {
        
        let context = persistentContainer.newBackgroundContext()
        do {
            let employee = try insertObject(type: Employee.self, managedObjectContext: context) { employee in
                
                employee.setup(name: name, salary: salary, workplaceNumber: workplaceNumber, lunchTime: lunchTime)
            }
            try context.save()
            completion(.success(employee))
        } catch {
            debugPrint(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    func fetchEmployee(completion:@escaping (Result<[Employee], Error>) -> Void) {
        
        let request: NSFetchRequest<Employee> = Employee.fetchRequest()
        
        do {
            let employees = try viewContext.fetch(request)
            completion(.success(employees))
        } catch {
            debugPrint(error.localizedDescription)
            completion(.failure(error))
        }
        
    }
    
    // MARK: Accountant
    
    func createAccountant(name: String, salary: Int, workplaceNumber: Int, lunchTime: Int, accountantType: Accountant.AccountantType, completion:@escaping (Result<Accountant, Error>) -> Void) {
        
        let context = persistentContainer.newBackgroundContext()
        do {
            let employee = try insertObject(type: Accountant.self, managedObjectContext: context) { employee in
                
                employee.setup(name: name, salary: salary, workplaceNumber: workplaceNumber, lunchTime: lunchTime, accountantType: accountantType)

            }
            try context.save()
            completion(.success(employee))
        } catch {
            debugPrint(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    func fetchAccountant(completion:@escaping (Result<[Accountant], Error>) -> Void) {
        
        let request: NSFetchRequest<Accountant> = Accountant.fetchRequest()
        
        do {
            let employees = try viewContext.fetch(request)
            completion(.success(employees))
        } catch {
            debugPrint(error.localizedDescription)
            completion(.failure(error))
        }
        
    }
    
//    func fetch<ManagedObject: Person>(completion:@escaping (Result<[ManagedObject], Error>) -> Void) {
//
//        let request = ManagedObject.fetchRequest()
//
//        do {
//            let employees = try viewContext.fetch(request)
//            completion(.success(employees))
//        } catch {
//            debugPrint(error.localizedDescription)
//            completion(.failure(error))
//        }
//
//    }
    
}
