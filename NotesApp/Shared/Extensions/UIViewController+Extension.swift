//
//  UIViewController+Extension.swift
//  NotesApp
//
//  Created by Andres Aleu on 20/11/24.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertOK(_ titleAlert: String, _ messageAlert: String, _ titleAction: String, _ style: UIAlertAction.Style, _ handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
        let action = UIAlertAction(title: titleAction, style: style, handler: handler)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
