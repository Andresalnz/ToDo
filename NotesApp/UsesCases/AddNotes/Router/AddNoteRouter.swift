//
//  AddNoteRouter.swift
//  NotesApp
//
//  Created by Andres Aleu on 18/11/24.
//

import Foundation
import UIKit

class AddNoteRouter {
    func showAddNote(_ viewController: UIViewController?) {
        let interactor = DataProvider()
        let presenter = AddNotePresenter(interactor: interactor)
        let view = AddNoteViewController(optionsAddOrEdit: .add, nibName: String(describing: AddNoteViewController.self), bundle: nil)
        presenter.interactor = interactor
        view.presenter = presenter
        view.ui = viewController as? NotesListViewController
        viewController?.navigationController?.pushViewController(view, animated: true)
    }
    
    func showEditNote(_ viewController: UIViewController?, _ note: ListNotes) {
        let interactor = DataProvider()
        let presenter = AddNotePresenter(interactor: interactor)
        let view = AddNoteViewController(optionsAddOrEdit: .edit(note), nibName: String(describing: AddNoteViewController.self), bundle: nil)
        presenter.interactor = interactor
        view.presenter = presenter
        view.ui = viewController as? NotesListViewController
        viewController?.navigationController?.pushViewController(view, animated: true)
    }
}
