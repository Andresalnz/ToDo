//
//  NoteListRouter.swift
//  NotesApp
//
//  Created by Andres Aleu on 13/11/24.
//

import Foundation
import UIKit

class NoteListRouter {
    var notesList: NotesListViewController?
    var navMain = UINavigationController()
    
    func router(window: UIWindow?) {
        let interactor = DataProvider()
        let presenter = NotesListPresenter(dataProvider: interactor, router: self)
        let view =  NotesListViewController()
        notesList = view
        presenter.ui = notesList
        notesList?.presenter = presenter
        view.presenter = presenter
        
        window?.rootViewController = navMain
        navMain.pushViewController(notesList ?? NotesListViewController(), animated: true)
        window?.makeKeyAndVisible()
    }
    
    func showAddNote() {
        let addNoteRouter = AddNoteRouter()
        guard let vc = notesList else { return }
        addNoteRouter.showAddNote(vc)
    }
}