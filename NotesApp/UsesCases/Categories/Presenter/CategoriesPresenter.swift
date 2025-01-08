//
//  CategoriesPresenter.swift
//  NotesApp
//
//  Created by Andres Aleu on 3/1/25.
//

import Foundation
import CoreData
class CategoriesPresenter: NSObject, NSFetchedResultsControllerDelegate {
    
    var interactor: DataProvider
    var ui: PresenterUi?
    var fetchedResultsController: NSFetchedResultsController<Categories>?
    
    init(interactor: DataProvider = DataProvider.shared) {
        self.interactor = interactor
    }
    
    func addCategory(titleCategory: String) throws {
        try interactor.addNote(.category, type: NSSQLiteStoreType, title: titleCategory)
        
    }
    
    func deleteCategory(category: Categories) throws {
        do {
            try  DataProvider.shared.deleteCat(category: category)
        } catch {
            print("No se ha podido borrar la nota")
        }
    }
    
    func numberNotes() -> Int {
        do {
           
            if let numberNotes = fetchTasks()?.count {
                return numberNotes
            }
        } catch let err {
            print("error pintando toda las tareas \(err.localizedDescription)")
        }
        return 0
    }
    
    func fetchTasks() -> [Categories]? {
        let sortDescriptors = [NSSortDescriptor(key: "nameCat", ascending: true)]
        fetchedResultsController = DataProvider.shared.configurarFetchedResultsController(
            for: .category,
            sortDescriptors: sortDescriptors
        )
        
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
            return fetchedResultsController?.fetchedObjects
           // return try DataProvider.shared.fetchTasks()
        } catch let err {
            print("Error pintando toda las tareas \(err.localizedDescription)")
            //Alerta
            return []
        }
    }
    
    func isSave() throws {
        try interactor.save()
    }
    
}
