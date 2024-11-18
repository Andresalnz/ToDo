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
        
    var tasks: [TaskList]
    
    
    init(dataProvider: DataProvider?, tasks: [TaskList] = [], router: NoteListRouter?) {
        self.dataProvider = dataProvider
        self.tasks = tasks
        self.router = router
    }
    
    func numberNotes() -> Int {
        do {
            if let numberNotes = try dataProvider?.fetchTasks()?.count {
                return numberNotes
            }
        } catch let err {
            print("error pintando toda las tareas \(err.localizedDescription)")
        }
     return 0
    }
    
    func fetchTasks() -> [TaskList]? {
        do {
            return try dataProvider?.fetchTasks()
        } catch let err {
            print("Error pintando toda las tareas \(err.localizedDescription)")
            //Alerta
            return []
        }
    }
    
    func deleteTask(at index: Int) throws {
       try dataProvider?.delete(task: tasks[index])
        ui?.update()
    }
    
    
    func buttonAddNote() {
        router?.showAddNote()
    }
}
