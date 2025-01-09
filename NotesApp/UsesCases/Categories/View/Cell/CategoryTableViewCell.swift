//
//  CategoryTableViewCell.swift
//  NotesApp
//
//  Created by Andres Aleu on 3/1/25.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryStackView: UIStackView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoryEditButton: UIButton!
    var isEditingCategory: Bool = false
    
    var category: String? = nil
    
    var trasformerCategory: ((String) throws -> Void)?
    
    static let identifier: String = "CategoryTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func styleCell(_ category: Categories) {
        
        categoryEditButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        categoryEditButton.tintColor = .black
        categoryTextField.text = category.nameCat
        categoryTextField.font = .RobotoRegular
        categoryTextField.borderStyle = .none
        categoryTextField.isUserInteractionEnabled = false
        
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        if isEditingCategory {
            categoryTextField.borderStyle = .none
            categoryTextField.isUserInteractionEnabled = false
            categoryEditButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            if let categoryTextFieldText = categoryTextField.text {
                do {
                    try trasformerCategory?(categoryTextFieldText)
                } catch let err {
                    print(err.localizedDescription)
                }
              
            }
            isEditingCategory = false
        } else {
            categoryTextField.borderStyle = .roundedRect
            categoryTextField.isUserInteractionEnabled = true
            categoryEditButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            isEditingCategory = true
        }
    }
}
