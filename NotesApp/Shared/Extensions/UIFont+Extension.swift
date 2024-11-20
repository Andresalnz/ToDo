//
//  UIFont+Extension.swift
//  NotesApp
//
//  Created by Andres Aleu on 20/11/24.
//

import Foundation
import UIKit

extension UIFont {
    static var RobotoRegular: UIFont {
        return  UIFont(name: "Roboto-Regular", size: 20) ?? systemFont(ofSize: 20)
    }
    
    static var RobotoLight: UIFont {
        return  UIFont(name: "Roboto-Light", size: 15) ?? systemFont(ofSize: 15)
    }
}
