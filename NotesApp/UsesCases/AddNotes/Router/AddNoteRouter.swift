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
        let view = AddNoteViewController()
        presenter.interactor = interactor
        view.presenter = presenter
        viewController?.navigationController?.pushViewController(view, animated: true)
    }
}
