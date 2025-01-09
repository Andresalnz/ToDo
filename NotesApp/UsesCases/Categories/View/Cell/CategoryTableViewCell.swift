//
//  CategoryTableViewCell.swift
//  NotesApp
//
//  Created by Andres Aleu on 3/1/25.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleCategory: UILabel!
    @IBOutlet weak var editButton: UIButton!
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
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.tintColor = .black
        
        titleCategory.text = category.nameCat
        titleCategory.font = .RobotoRegular
        
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        print("editar")
    }
    
    
}
