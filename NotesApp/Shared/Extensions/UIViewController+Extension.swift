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
    
    func showAlertTwoOptions(_ titleAlert: String, _ titleAction1: String, _ style1: UIAlertAction.Style, _ handler1: @escaping ((UIAlertAction) -> Void), _ titleAction2: String, _ style2: UIAlertAction.Style, _ handler2:  ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: titleAlert, message: nil, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: titleAction1, style: style1, handler: handler1)
        let actionCancel = UIAlertAction(title: titleAction2, style: style2, handler: handler2)
        alert.addAction(actionOK)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
}
