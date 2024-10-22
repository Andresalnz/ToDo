//
//  EditPresenter.swift
//  NotesApp
//
//  Created by Andres Aleu on 18/10/24.
//

import Foundation

class EditPresenter {
    
    var interactor: DataProvider = DataProvider()
    
    init(interactor: DataProvider) {
        self.interactor = interactor
    }
    
    func saveTask() throws {
        
      try interactor.save()
    }
}
