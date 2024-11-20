//
//  UITextView+Extension.swift
//  NotesApp
//
//  Created by Andres Aleu on 20/11/24.
//

import Foundation
import UIKit

extension UITextView {
    func configureStyleTextView(_ text: String, _ font: UIFont, _ textColor: UIColor, autoCapitalization: UITextAutocapitalizationType) {
        self.font = font
        self.text = text
        self.textColor = textColor
        self.autocapitalizationType = autoCapitalization
    }
}
