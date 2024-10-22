//
//  TaskTableViewCell.swift
//  NotesApp
//
//  Created by Andres Aleu on 17/10/24.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let identifier: String = "TaskTableViewCell"

    @IBOutlet weak var task: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configurePrint(with task: TaskList) {
        self.task.text = task.name
    }
}
