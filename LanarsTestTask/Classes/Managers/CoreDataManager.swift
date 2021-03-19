//
//  CoreDataManager.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 17.03.2021.
//

import CoreData
import Foundation

final class CoreDataManager {
    
    // MARK: - Typealias
    
    typealias AllData = ListViewController.PersonsTableViewData.AllData
    
    // MARK: - SortBy
    
    enum SortBy: RawRepresentable {
        
        case id
        case name
        
        typealias RawValue = Bool
        var rawValue: RawValue {
            return self == .id ? true : false
        }
        init?(rawValue: RawValue) {
            self = rawValue == true ? .id : .name
        }
    }
    
    // MARK: - Statics
    
    static let shared = CoreDataManager()
    
    // MARK: - Private properties
    
    private let modelName = "LanarsTestTask"
    private let persistentContainer: NSPersistentContainer
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - User defaults

    var isEdited: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isEdited")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isEdited")
        }
    }
    
    // MARK: - Lifecycle
    
    private init() {
        
        let fileURL = FileManager.libraryURL().appendingPathComponent(modelName).appendingPathExtension("sqlite")
        let container = NSPersistentContainer(name: modelName)
        let fileDescription = NSPersistentStoreDescription(url: fileURL)
        container.persistentStoreDescriptions = [fileDescription]
        
        persistentContainer = container
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    // MARK: Management
    
    func createManagement(id: Int? = nil, name: String, salary: Int, receptionHours: Int, completion: @escaping (Result<Management, Error>) -> Void) {
        
        create(object: Management.self, id: id, name: name, salary: salary, workplaceNumber: 0, receptionHours: receptionHours, lunchTime: 0, accountantType: .payroll, completion: completion)
    }
    
    // MARK: Employee
    
    func createEmployee(id: Int?, name: String, salary: Int, workplaceNumber: Int, lunchTime: Int, completion: @escaping (Result<Employee, Error>) -> Void) {
        
        create(object: Employee.self, id: id, name: name, salary: salary, workplaceNumber: workplaceNumber, receptionHours: 0, lunchTime: lunchTime, accountantType: .payroll, completion: completion)
    }
    
    // MARK: Accountant
    
    func createAccountant(id: Int?, name: String, salary: Int, workplaceNumber: Int, lunchTime: Int, accountantType: Accountant.AccountantType, completion:@escaping (Result<Accountant, Error>) -> Void) {
        
        create(object: Accountant.self, id: id, name: name, salary: salary, workplaceNumber: workplaceNumber, receptionHours: 0, lunchTime: lunchTime, accountantType: accountantType, completion: completion)
    }
    
    // MARK: - Create
    
    private func create<ManagedObject: NSManagedObject>(object: ManagedObject.Type,
                                                        id: Int?,
                                                        name: String,
                                                        salary: Int,
                                                        workplaceNumber: Int,
                                                        receptionHours: Int,
                                                        lunchTime: Int,
                                                        accountantType: Accountant.AccountantType,
                                                        completion:@escaping (Result<ManagedObject, Error>) -> Void) {
        
        
        let context = persistentContainer.newBackgroundContext()
        let request: NSFetchRequest<ManagedObject> = ManagedObject.fetchRequest()
        request.includesSubentities = false
        
        do {
            
            let newId = id != nil ? id! : try context.count(for: request)
            let employee = try insertObject(type: ManagedObject.self, managedObjectContext: context) { object in
                
                if let management = object as? Management {
                    
                    management.setup(id: newId,
                                     name: name,
                                     salary: Int(salary))
                    
                } else if let accountant = object as? Accountant {
                    
                    accountant.setup(id: newId,
                                     name: name,
                                     salary: Int(salary),
                                     workplaceNumber: Int(workplaceNumber),
                                     lunchTime: Int(lunchTime),
                                     accountantType: accountantType)
                    
                } else if let employee = object as? Employee {
                    
                    employee.setup(id: newId,
                                   name: name,
                                   salary: Int(salary),
                                   workplaceNumber: Int(workplaceNumber),
                                   lunchTime: Int(lunchTime))
                    
                }
            }
            completion(.success(employee))
            try context.save()
        } catch {
            debugPrint(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    // MARK: - Read
    
    func read<ManagedObject: NSManagedObject>(object: ManagedObject.Type, sortBy: SortBy, completion: @escaping (Result<[ManagedObject], Error>) -> Void) {
        
        let request: NSFetchRequest<ManagedObject> = ManagedObject.fetchRequest()
        
        let sort: NSSortDescriptor
        switch sortBy {
        case .id:
            sort = NSSortDescriptor(key: "id", ascending: true)
        case .name:
            sort = NSSortDescriptor(key: "name", ascending: true)
        }
        request.sortDescriptors = [sort]
        request.includesSubentities = false
        
        do {
            let objects = try viewContext.fetch(request)
            completion(.success(objects))
        } catch {
            debugPrint(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    func readAll(completion: @escaping (Result<AllData, Error>) -> Void) {
        
        let group = DispatchGroup()
        var allData: AllData = ([], [], [])
        let sortBy: SortBy = SortBy(rawValue: isEdited) ?? .name
        
        DispatchQueue.global(qos: .background).async(group: group) {
            
            group.enter()
            self.read(object: Management.self, sortBy: sortBy) { result in
                switch result {
                case .success(let ent):
                    allData.management = ent
                case .failure(let error):
                    completion(.failure(error))
                }
                group.leave()
            }
            
            group.enter()
            self.read(object: Employee.self, sortBy: sortBy) { result in
                switch result {
                case .success(let ent):
                    allData.employee = ent
                case .failure(let error):
                    completion(.failure(error))
                }
                group.leave()
            }
            
            group.enter()
            self.read(object: Accountant.self, sortBy: sortBy) { result in
                switch result {
                case .success(let ent):
                    allData.accountant = ent
                case .failure(let error):
                    completion(.failure(error))
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            completion(.success(allData))
        }
    }
    
    
    // MARK: - Update
    
    func update<ManagedObject: NSManagedObject>(object: ManagedObject.Type, with array: [ManagedObject], completion: @escaping (Result<[ManagedObject], Error>) -> Void) {
        
        let context = persistentContainer.newBackgroundContext()
        let request: NSFetchRequest<ManagedObject> = ManagedObject.fetchRequest()
        
        do {
            try context.fetch(request).forEach { context.delete($0) }
            
            for index in 0..<array.count {
                
                let newObject = array[index]
                try insertObject(type: ManagedObject.self, managedObjectContext: context) { object in
                    
                    if let management = object as? Management, let newManagement = newObject as? Management  {
                        
                        management.setup(id: index,
                                         name: newManagement.name,
                                         salary: Int(newManagement.salary))
                        
                    } else if let accountant = object as? Accountant, let newAccountant = newObject as? Accountant {
                        
                        accountant.setup(id: index,
                                         name: newAccountant.name,
                                         salary: Int(newAccountant.salary),
                                         workplaceNumber: Int(newAccountant.workplaceNumber),
                                         lunchTime: Int(newAccountant.lunchTime),
                                         accountantType: Accountant.AccountantType(rawValue: newAccountant.accountantType) ?? .payroll)
                        
                    } else if let employee = object as? Employee, let newEmployee = newObject as? Employee {
                        
                        employee.setup(id: index,
                                       name: newEmployee.name,
                                       salary: Int(newEmployee.salary),
                                       workplaceNumber: Int(newEmployee.workplaceNumber),
                                       lunchTime: Int(newEmployee.lunchTime))
                        
                    }
                }
            }
            
            try context.save()
        } catch {
            print("Save Failed: \(error)")
        }
    }
    
    func updateAll(personsTableViewData: AllData, completion: @escaping (Result<AllData, Error>) -> Void) {
        
        let group = DispatchGroup()
        var allData: AllData = ([], [], [])

        DispatchQueue.global(qos: .background).async(group: group) {
            
            group.enter()
            self.update(object: Management.self, with: personsTableViewData.management) { result in
                switch result {
                case .success(let ent):
                    allData.management = ent
                case .failure(let error):
                    completion(.failure(error))
                }
                group.leave()
            }
            group.enter()
            self.update(object: Employee.self, with: personsTableViewData.employee) { result in
                switch result {
                case .success(let ent):
                    allData.employee = ent
                case .failure(let error):
                    completion(.failure(error))
                }
                group.leave()
            }
            group.enter()
            self.update(object: Accountant.self, with: personsTableViewData.accountant) { result in
                switch result {
                case .success(let ent):
                    allData.accountant = ent
                case .failure(let error):
                    completion(.failure(error))
                }
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            completion(.success(allData))
        }
    }
    
    // MARK: - Delete
    
    func delete<ManagedObject: NSManagedObject>(object: ManagedObject.Type, id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let context = persistentContainer.newBackgroundContext()
        
        let request: NSFetchRequest<ManagedObject> = ManagedObject.fetchRequest()
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
    
    @discardableResult
    private func insertObject<ManagedObject: NSManagedObject>(type: ManagedObject.Type, managedObjectContext: NSManagedObjectContext, configuration: (ManagedObject) -> Void) throws -> ManagedObject {
        
        let entity = ManagedObject.entity()
        let object: ManagedObject = ManagedObject(entity: entity, insertInto: managedObjectContext)
        
        configuration(object)
        return object
    }
}
