//
//  ListOfTasksViewController.swift
//  NotesApp
//
//  Created by Andres Aleu on 17/10/24.
//

import UIKit

class NotesListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbarView: UIToolbar!
    var presenter: NotesListPresenter?
    @IBOutlet var containerView: UIView!
    var actions: [UIAction] = []
    var buttonsItem: [UIBarButtonItem] = []
    let appearance = UINavigationBarAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        createNavigationBar()
        createButtonsItem()
        createButtonsItemsToolbar()
    }
    
    
    func configureTable() {
        tableView.dataSource = self
        tableView.delegate = self
        registerCell()
    }
   
    func registerCell() {
        let nib = UINib(nibName: String(describing: NoteTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: NoteTableViewCell.identifier)
    }
    
   @objc func pushScreenaddNote() {
       presenter?.addOrEditNote(note: nil)
    }
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension NotesListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rowsInSection = presenter?.numberNotes() {
            return rowsInSection
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellTask: NoteTableViewCell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell else { return UITableViewCell() }
        
        let notes = presenter?.fetchTasks()
        guard let note = notes?[indexPath.row] else { return UITableViewCell() }
        
        cellTask.configurePrint(with: note)
        cellTask.selectionStyle = .none
        
        return cellTask
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notes = presenter?.fetchTasks()
        guard let note = notes?[indexPath.row] else { return }
        presenter?.addOrEditNote(note: note)
    }
//    
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        do {
//            try presenter?.deleteTask(at: indexPath.row)
//        } catch let err {
//            print("Error al borrar la tarea: \(err.localizedDescription)")
//        }
//        
//        
//    }
}

//MARK: - ConfigurationNavigationBar, ConfigurationMenuButtonItem
extension NotesListViewController: ConfigurationNavigationBar, ConfigurationMenuButtonItem {
    func createButtonsItem() {
        let buttonMenu = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
        buttonsItem.append(contentsOf: [buttonMenu])
        self.navigationItem.setRightBarButtonItems(buttonsItem, animated: true)
        
        createAcctionsAndMenu(button: buttonMenu)
    }
    
    func createAcctionsAndMenu(button: UIBarButtonItem) {
        let action1 = UIAction(title: "Action 1", image: UIImage(systemName: "star"), handler: { _ in print("1") })
        let action2 = UIAction(title: "Action 1", image: UIImage(systemName: "star"), handler: { _ in print("2") })
        let action3 = UIAction(title: "Action 1", image: UIImage(systemName: "star"), handler: { _ in print("3") })
        actions.append(contentsOf: [action1, action2, action3])
        
        let menu = UIMenu(title: "", options: .destructive, children: actions)
        button.menu = menu
    }
    
    func createNavigationBar() {
        self.navigationController?.navigationBar.navigationBarWithApperance(appearance, isTranslucent: false, barstyle: .black, title: "Notes", color: .systemGray6, prefersLargeTitles: true)
    }
}

//MARK: - ConnfigurationToolbar
extension NotesListViewController: ConfigurationToolbar {
    func configureToolbar(_ arrayButtons: [UIBarButtonItem]) {
        toolbarItems = arrayButtons
        toolbarView.items = toolbarItems
        toolbarView.backgroundColor = .systemGray6
    }
    
    func createButtonsItemsToolbar() {
        var buttons: [UIBarButtonItem] = []
        let buttonSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let buttonAdd = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(pushScreenaddNote))
        buttons.append(contentsOf: [buttonSpace, buttonAdd])
        configureToolbar(buttons)
    }
}

//MARK: - PresenterUi
extension NotesListViewController: PresenterUi {
    func update() {
        self.tableView.reloadData()
    }
}
