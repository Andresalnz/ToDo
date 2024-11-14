//
//  Toolbar+Protocol.swift
//  NotesApp
//
//  Created by Andres Aleu on 14/11/24.
//

import Foundation
import UIKit

protocol ConfigurationToolbar {
    func configureToolbar(_ arrayButtons: [UIBarButtonItem])
    func createButtonsItemsToolbar()
}
