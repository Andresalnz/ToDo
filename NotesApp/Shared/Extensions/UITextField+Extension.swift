//
//  UITextField+Extension.swift
//  NotesApp
//
//  Created by Andres Aleu on 20/11/24.
//

import Foundation
import UIKit

extension UITextField {
    func configureStyleTextField(_ placeholder: String?, _ text: String?, _ font: UIFont, _ borderStyle: UITextField.BorderStyle, autoCapitalization: UITextAutocapitalizationType) {
        self.placeholder = placeholder
        self.text = text
        self.font = font
        self.borderStyle = borderStyle
        self.autocapitalizationType = autoCapitalization
    }
}
