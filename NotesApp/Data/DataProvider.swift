//
//  DataProvider.swift
//  NotesApp
//
//  Created by Andres Aleu on 17/10/24.
//

import Foundation
import CoreData

protocol DataProviderProtocol {
    func addTask(type: String, title: String, detail: String) throws
    func fetchTasks() throws -> [TaskList]
    func save() throws
    func delete(task: TaskList) throws
   
}

protocol DataProviderUi: AnyObject {
    func update()
    //adtask
    
}

class DataProvider {
   
    
    //MARK: - Singleton
    static let shared = DataProvider()

    //MARK: - NSPersistentContainer, NSManagedObjectContext
    
    
    private let container: NSPersistentContainer
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    init() {
        self.container = NSPersistentContainer(name: "NotesAppModel")
        self.container.persistentStoreDescriptions.first?.type = NSSQLiteStoreType
        self.container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
    }

}



//MARK: - DataProviderProtocol
extension DataProvider: DataProviderProtocol {
    //MARK: - CRUD
    func save() throws {
        if context.hasChanges {
           try context.save()
        }
    }
    
    func addTask(type: String, title: String, detail: String) throws {
        guard let entityDescription = NSEntityDescription.entity(forEntityName:"TaskList", in: context) else {
            return
        }
        
        
        let task = TaskList(entity: entityDescription, insertInto: context)
        task.name = title
        task.detail = detail
        
        try save()
    }
    
    func fetchTasks() throws -> [TaskList] {
        let request: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        return try context.fetch(request)
    }
    

    
    func delete(task: TaskList) throws {
        context.delete(task)
        try save()
    }
}



