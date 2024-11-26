//
//  AddNoteRouter.swift
//  NotesApp
//
//  Created by Andres Aleu on 18/11/24.
//

import Foundation
import UIKit

class AddAndEditNoteRouter {
    func showAddNote(_ viewController: UIViewController?) {
        let interactor = DataProvider()
        let presenter = AddAndEditNotePresenter(interactor: interactor)
        let view = AddAndEditNoteViewController(optionsAddOrEdit: .add, nibName: String(describing: AddAndEditNoteViewController.self), bundle: nil)
        presenter.interactor = interactor
        view.presenter = presenter
        view.ui = viewController as? NotesListViewController
        viewController?.navigationController?.pushViewController(view, animated: true)
    }
    
    func showEditNote(_ viewController: UIViewController?, _ note: ListNotes) {
        let interactor = DataProvider()
        let presenter = AddAndEditNotePresenter(interactor: interactor)
        let view = AddAndEditNoteViewController(optionsAddOrEdit: .edit(note), nibName: String(describing: AddAndEditNoteViewController.self), bundle: nil)
        presenter.interactor = interactor
        view.presenter = presenter
        view.ui = viewController as? NotesListViewController
        viewController?.navigationController?.pushViewController(view, animated: true)
    }
}
