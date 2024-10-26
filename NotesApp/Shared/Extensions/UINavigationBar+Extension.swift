//
//  UINavigationBar+Extension.swift
//  NotesApp
//
//  Created by Andres Aleu on 23/10/24.
//

import Foundation
import UIKit

extension UINavigationBar {
    func navigationBarWithApperance(_ apperance: UINavigationBarAppearance, isTranslucent: Bool, barstyle: UIBarStyle, title: String, color: UIColor, prefersLargeTitles: Bool) {
        apperance.configureWithOpaqueBackground()
        apperance.backgroundColor = color
        self.barStyle = barstyle
        self.isTranslucent = isTranslucent
        self.topItem?.title = title
        self.prefersLargeTitles = prefersLargeTitles
        self.topItem?.largeTitleDisplayMode = .automatic
        self.standardAppearance = apperance
        self.scrollEdgeAppearance = apperance
    }
}
