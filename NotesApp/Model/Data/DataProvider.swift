//
//  DataProvider.swift
//  NotesApp
//
//  Created by Andres Aleu on 17/10/24.
//

import Foundation
import CoreData

protocol DataProviderProtocol {
    func addNote(type: String, title: String, descriptionNote: String, dateNote: Date) throws
    func fetchTasks() throws -> [ListNotes]?
    func save() throws
    func delete(note: ListNotes) throws
    func configurarFetchedResultsController()
}

class DataProvider: NSObject {
   
    //MARK: - NSFetchedResultsController
    var fetchedResultsController: NSFetchedResultsController<ListNotes>?
    
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
        let request: NSFetchRequest<ListNotes> = ListNotes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
    }
    //MARK: - CRUD
    func save() throws {
        if context.hasChanges {
           try context.save()
        }
    }
    
    func addNote(type: String, title: String, descriptionNote: String, dateNote: Date) throws {
        guard let entityDescription = NSEntityDescription.entity(forEntityName:"ListNotes", in: context) else {
            return
        }
        
        let task = ListNotes(entity: entityDescription, insertInto: context)
        task.title = title
        task.descriptionNote = descriptionNote
        task.date = dateNote
        
        try save()
    }
    
    func fetchTasks() throws -> [ListNotes]?  {
        try fetchedResultsController?.performFetch()
        return fetchedResultsController?.fetchedObjects
    }
    

    
    func delete(note: ListNotes) throws {
        context.delete(note)
        
        try save()
    }
}



