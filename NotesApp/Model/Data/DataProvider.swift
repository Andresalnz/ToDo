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
    func fetchTasks() throws -> [TaskList]?
    func save() throws
    func delete(task: TaskList) throws
    func configurarFetchedResultsController()
}

class DataProvider: NSObject {
   
    //MARK: - NSFetchedResultsController
    var fetchedResultsController: NSFetchedResultsController<TaskList>?
    
    //MARK: - Singleton
    static let shared = DataProvider()

    //MARK: - NSPersistentContainer, NSManagedObjectContext
    
    
    private let container: NSPersistentContainer
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    override init() {
        self.container = NSPersistentContainer(name: "NotesAppModel")
        self.container.persistentStoreDescriptions.first?.type = NSSQLiteStoreType
        self.container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        super.init()
        configurarFetchedResultsController()
    }

}



//MARK: - DataProviderProtocol, NSFetchedResultsControllerDelegate
extension DataProvider: DataProviderProtocol, NSFetchedResultsControllerDelegate {
    
    func configurarFetchedResultsController()  {
        let request: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
    }
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
    
    func fetchTasks() throws -> [TaskList]?  {
        try fetchedResultsController?.performFetch()
        return fetchedResultsController?.fetchedObjects
    }
    

    
    func delete(task: TaskList) throws {
        context.delete(task)
        try save()
    }
}



