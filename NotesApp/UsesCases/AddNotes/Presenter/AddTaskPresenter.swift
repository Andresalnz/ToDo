//
//  AddTaskPresenter.swift
//  NotesApp
//
//  Created by Andres Aleu on 17/10/24.
//

import Foundation
import CoreData

protocol AddNotePresenterProtocol: AnyObject {
    func addTask(name: String?, description: String?)
}

class AddTaskPresenter {
    
    
    var interactor: DataProvider = DataProvider()
    
    init(interactor: DataProvider) {
        self.interactor = interactor
    }
    
    func addTask(name: String?, description: String?) throws {
    
          
        try interactor.addTask(type: NSSQLiteStoreType, title: name ?? "" , detail: description ?? "")
        
    }
}
