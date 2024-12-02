//
//  ListOfTasksPresenter.swift
//  NotesApp
//
//  Created by Andres Aleu on 17/10/24.
//

import Foundation

class NotesListPresenter {
    
     let dataProvider: DataProvider?
     var ui: PresenterUi?
    var router: NoteListRouter?
        

    
    
    init(dataProvider: DataProvider?, tasks: [ListNotes] = [], router: NoteListRouter?) {
        self.dataProvider = dataProvider
        self.router = router
    }
    
    func numberNotes() -> Int {
        do {
            if let numberNotes = try DataProvider.shared.fetchTasks()?.count {
                return numberNotes
            }
        } catch let err {
            print("error pintando toda las tareas \(err.localizedDescription)")
        }
     return 0
    }
    
    func fetchTasks() -> [ListNotes]? {
        do {
            return try DataProvider.shared.fetchTasks()
        } catch let err {
            print("Error pintando toda las tareas \(err.localizedDescription)")
            //Alerta
            return []
        }
    }
    
    func deleteTask(note: ListNotes) throws {
        do {
         try  DataProvider.shared.delete(note: note)
        } catch {
            print("No se ha podido borrar la nota")
        }
    }
    
    
    func addOrEditNote(note: ListNotes?) {
        if let note = note {
            router?.showEditNote(note: note)
        } else {
            router?.showAddNote()
        }
        
    }
}
