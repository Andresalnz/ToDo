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
    func editNote(title: String?, descriptionNote: String?, date: Date, note: ListNotes, _ handler: (() -> Void)?) throws
}

class AddAndEditNotePresenter {
    
    
    var interactor: DataProvider = DataProvider()
    var ui: PresenterUi?
    
    init(interactor: DataProvider) {
        self.interactor = interactor
    }
}

extension AddAndEditNotePresenter: AddNotePresenterProtocol {
    func addNote(title: String?, descriptionNote: String?, date: Date) throws {
        guard let title = title, let descriptionNote = descriptionNote else {
            throw fatalError()
        }
       try interactor.addNote(type: NSSQLiteStoreType, title: title , descriptionNote: descriptionNote, dateNote: date)
    }
    
    func editNote(title: String?, descriptionNote: String?, date: Date, note: ListNotes, _ handler: (() -> Void)?) throws {
        if let descriptionNote = descriptionNote, descriptionNote != note.descriptionNote {
            note.descriptionNote = descriptionNote
        }
        
        if title != note.title {
            note.title = title
        }
        
        //note.date = date
        print(note)
        if note.isUpdated == true {
            try isSave()
            handler?()
        } else {
            handler?()
        }
    }
    
    func isSave() throws {
       try interactor.save()
    }
    
    func deleteTask(idNote: ListNotes) throws {
        do {
            try interactor.delete(note: idNote)
            ui?.update()
        } catch {
            print("No se ha podido borrar la nota")
        }
    }
    
}
