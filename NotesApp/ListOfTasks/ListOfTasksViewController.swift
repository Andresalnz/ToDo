//
//  ListOfTasksViewController.swift
//  NotesApp
//
//  Created by Andres Aleu on 17/10/24.
//

import UIKit

class ListOfTasksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTaskButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        // Do any additional setup after loading the view.
    }

    func configureTable() {
        tableView.dataSource = self
        tableView.delegate = self
        title = "Task List"
        registerCell()
    }
   
    func registerCell() {
        let nib = UINib(nibName: String(describing: TaskTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TaskTableViewCell.identifier)
    }
    @IBAction func addTaskButtonAction(_ sender: Any) {
        let view = AddTaskViewController(nibName: String(describing: AddTaskViewController.self), bundle: nil)
        navigationController?.pushViewController(view, animated: true)
    }
}


extension ListOfTasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellTask: TaskTableViewCell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        
        cellTask.task.text = "Task 1"
        return cellTask
    }
    
}
