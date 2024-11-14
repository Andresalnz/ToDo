//
//  ListOfTasksPresenter.swift
//  NotesApp
//
//  Created by Andres Aleu on 17/10/24.
//

import Foundation


enum StatusNotes {
    case loading
    case loaded
    case error
}

class NotesListPresenter {
    
     let dataProvider: DataProvider?
     var ui: PresenterUi?
    
    var tasks: [TaskList]
    
    var status: ((StatusNotes) -> Void)?
    
    init(dataProvider: DataProvider?, tasks: [TaskList] = []) {
        self.dataProvider = dataProvider
        self.tasks = tasks
       
    }
    
    func viewDidLoad() {
        fetchTasks()
        
    }
    
    func fetchTasks() {
        do {
            let data = try dataProvider?.fetchTasks()
            tasks = data ?? []
            
            
        } catch let err {
            print("Error pintando toda las tareas \(err.localizedDescription)")
            //Alerta
        }
    }
    
    func deleteTask(at index: Int) throws {
       try dataProvider?.delete(task: tasks[index])
        ui?.update()
    }
}
