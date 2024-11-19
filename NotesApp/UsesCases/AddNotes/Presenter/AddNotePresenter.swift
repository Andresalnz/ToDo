//
//  AddTaskPresenter.swift
//  NotesApp
//
//  Created by Andres Aleu on 17/10/24.
//

import Foundation
import CoreData

protocol AddNotePresenterProtocol: AnyObject {
    func addNote(title: String?, descriptionNote: String?, date: Date) throws
}

class AddNotePresenter {
    
    
    var interactor: DataProvider = DataProvider()
    
    init(interactor: DataProvider) {
        self.interactor = interactor
    }
}

extension AddNotePresenter: AddNotePresenterProtocol {
    func addNote(title: String?, descriptionNote: String?, date: Date) throws {
        guard let title = title, let descriptionNote = descriptionNote else {
            throw fatalError()
        }
       try interactor.addNote(type: NSSQLiteStoreType, title: title , descriptionNote: descriptionNote, dateNote: date)
    }
    
    
}
