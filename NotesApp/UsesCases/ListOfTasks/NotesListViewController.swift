//
//  ListOfTasksViewController.swift
//  NotesApp
//
//  Created by Andres Aleu on 17/10/24.
//

import UIKit

class NotesListViewController: UIViewController, DataProviderUi {

    @IBOutlet weak var tableView: UITableView!
    
    var presenter: NotesListPresenter?
    
    var actions: [UIAction] = []
    var buttonsItem: [UIBarButtonItem] = []
    let appearance = UINavigationBarAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        createNavigationBar()
        createButtonsItem()
    }
    
    func update() {
        presenter?.fetchTasks()
        self.tableView.reloadData()
        
    }
    
    func configureTable() {
        tableView.dataSource = self
        tableView.delegate = self
        registerCell()
        presenter?.fetchTasks()
    }
   
    func registerCell() {
        let nib = UINib(nibName: String(describing: NoteTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: NoteTableViewCell.identifier)
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
extension NotesListViewController: UITableViewDataSource, UITableViewDelegate {
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
        guard let cellTask: NoteTableViewCell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell else { return UITableViewCell() }
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

extension NotesListViewController: ConfigurationNavigationBar, ConfigurationMenuButtonItem {
    func createAndConfigureMenuButtonItem(button: UIBarButtonItem) {
        let menu = UIMenu(title: "", options: .destructive, children: actions)
        button.menu = menu
    }
    
    
    func createButtonsItem() {
        let buttonMenu = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
        buttonsItem.append(contentsOf: [buttonMenu])
        self.navigationItem.setRightBarButtonItems(buttonsItem, animated: true)
        createAcctionMenu()
        createAndConfigureMenuButtonItem(button: buttonMenu)
    }
    
    func createAcctionMenu() {
        let action1 = UIAction(title: "Action 1", image: UIImage(systemName: "star"), handler: { _ in print("1") })
        let action2 = UIAction(title: "Action 1", image: UIImage(systemName: "star"), handler: { _ in print("2") })
        let action3 = UIAction(title: "Action 1", image: UIImage(systemName: "star"), handler: { _ in print("3") })
        actions.append(contentsOf: [action1, action2, action3])
    }
    
    func createNavigationBar() {
        self.navigationController?.navigationBar.navigationBarWithApperance(appearance, isTranslucent: false, barstyle: .black, title: "Notes", color: .systemGray6, prefersLargeTitles: true)
    }
}
