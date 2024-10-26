//
//  NavigationBar+Protocol.swift
//  NotesApp
//
//  Created by Andres Aleu on 25/10/24.
//

import Foundation
import UIKit

protocol ConfigurationNavigationBar {
    func createButtonsItem()
}

protocol ConfigurationMenuButtonItem {
    func createAndConfigureMenuButtonItem(button: UIBarButtonItem)
    func createAcctionMenu()
}
