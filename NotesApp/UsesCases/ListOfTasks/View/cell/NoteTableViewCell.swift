//
//  TaskTableViewCell.swift
//  NotesApp
//
//  Created by Andres Aleu on 17/10/24.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    static let identifier: String = "TaskTableViewCell"

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var descriptionNote: UILabel!
    
    @IBOutlet weak var dateNote: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configurePrint(with note: ListNotes) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es")
        dateFormatter.dateFormat = "dd/MM/yy"
        
        self.descriptionNote.numberOfLines = 2
        self.title.font = .RobotoRegular
        self.descriptionNote.font = .RobotoLight
        self.title.text = note.title
        
        if note.descriptionNote == "" {
            self.descriptionNote.text = "No description"
        } else {
            self.descriptionNote.text = note.descriptionNote
        }
       
        
        if let dateNote = note.date {
            self.dateNote.text = dateFormatter.string(from: dateNote)
            self.dateNote.font = .RobotoLight
        }
    }
}
