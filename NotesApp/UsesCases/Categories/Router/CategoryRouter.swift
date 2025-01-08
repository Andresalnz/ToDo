//
//  CategoryRouter.swift
//  NotesApp
//
//  Created by Andres Aleu on 3/1/25.
//

import Foundation
import UIKit

class CategoryRouter {
    
    func showCategory(_ viewController: UIViewController?) {
        let interactor = DataProvider()
        let presenter = CategoriesPresenter(interactor: interactor)
        let view = ListCategoriesViewController(nibName: String(describing: ListCategoriesViewController.self), bundle: nil)
        presenter.interactor = interactor
        view.presenter = presenter
        viewController?.navigationController?.pushViewController(view, animated: true)
    }
}
