//
//  DataProvider.swift
//  NotesApp
//
//  Created by Andres Aleu on 17/10/24.
//

import Foundation
import CoreData

protocol DataProviderProtocol {
    func addNote(_ forEntityName: forEntity, type: String, title: String, descriptionNote: String?, dateNote: Date?) throws
    func save() throws
    func delete(note: ListNotes) throws
    func configurarFetchedResultsController<T: NSManagedObject>(for entity: forEntity, sortDescriptors: [NSSortDescriptor]?) -> NSFetchedResultsController<T>
}

enum forEntity: String {
    case note = "ListNotes"
    case category = "Categories"
}

class DataProvider: NSObject {
    
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
        
    }

}


//MARK: - DataProviderProtocol, NSFetchedResultsControllerDelegate
extension DataProvider: DataProviderProtocol, NSFetchedResultsControllerDelegate {
    
    func configurarFetchedResultsController<T: NSManagedObject>(for entity: forEntity, sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchedResultsController<T> {
        let entityName = entity.rawValue
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.sortDescriptors = sortDescriptors
        let fetchedResults = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

        return fetchedResults
    }
    //MARK: - CRUD
    func save() throws {
        if context.hasChanges {
           try context.save()
        }
    }
    
    func addNote(_ forEntityName: forEntity, type: String, title: String, descriptionNote: String? = nil, dateNote: Date? = nil) throws {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: forEntityName.rawValue, in: context) else {
            return
        }
        
        switch forEntityName {
            case .note:
                let note = ListNotes(entity: entityDescription, insertInto: context)
                note.title = title
                note.descriptionNote = descriptionNote
                note.date = dateNote
            case .category:
                let category = Categories(entity: entityDescription, insertInto: context)
                category.nameCat = title
        }
     
        try save()
    }
    
    func delete(note: ListNotes) throws {
        context.delete(note)
        
        try save()
    }
    
    func deleteCat(category: Categories) throws {
        context.delete(category)
        
        try save()
    }
}



