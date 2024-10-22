//
//  ListOfTasksViewController.swift
//  NotesApp
//
//  Created by Andres Aleu on 17/10/24.
//

import UIKit

class ListOfTasksViewController: UIViewController, DataProviderUi {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTaskButton: UIButton!
    
    var presenter: ListOfTasksPresenter?
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
    }
    
  
    func update() {
        presenter?.fetchTasks()
        self.tableView.reloadData()
        
    }
    
    func configureTable() {
        tableView.dataSource = self
        tableView.delegate = self
        title = "Task List"
        registerCell()
        presenter?.fetchTasks()
    }
   
    func registerCell() {
        let nib = UINib(nibName: String(describing: TaskTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TaskTableViewCell.identifier)
    }
    
    @IBAction func addTaskButtonAction(_ sender: Any) {
        router()
    }
    
    func router() {
        let interactor = DataProvider()
        let presenter = AddTaskPresenter(interactor: interactor)
        let view = AddNoteViewController()
        view.ui = self
        view.presenter = presenter
        navigationController?.pushViewController(view, animated: true)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension ListOfTasksViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rowsInSection = presenter?.tasks.count {
            return rowsInSection
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellTask: TaskTableViewCell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        if let task = presenter?.tasks[indexPath.row] {
            cellTask.configurePrint(with: task)
        
        }
        
        
        return cellTask
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = presenter?.tasks[indexPath.row]
        
        let interactor = DataProvider()
        let presenter = EditNotePresenter(interactor: interactor)
        let view = EditNoteViewController(task: task, nibName: String(describing: EditNoteViewController.self), bundle: nil)
        view.ui = self
        view.presenter = presenter
        navigationController?.pushViewController(view, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        do {
            try presenter?.deleteTask(at: indexPath.row)
        } catch let err {
            print("Error al borrar la tarea: \(err.localizedDescription)")
        }
        
        
    }
}
