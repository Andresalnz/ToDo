//
//  ListCategoriesViewController.swift
//  NotesApp
//
//  Created by Andres Aleu on 24/12/24.
//

import UIKit

class ListCategoriesViewController: UIViewController {
    
    @IBOutlet weak var categoriesStackView: UIStackView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    
    var presenter: CategoriesPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
     
    }

    func style() {
        categoryTextField.configureStyleTextField("Add Category", nil, .RobotoRegular, .roundedRect, autoCapitalization: .sentences)
        addCategoryButton.setTitle("DONE", for: .normal)
        addCategoryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        categoriesStackView.spacing = 0
    }
    
    func configureView() {
        style()
        configureTableView()
    }
    func registerCell() {
        let nib = UINib(nibName: String(describing: CategoryTableViewCell.self), bundle: nil)
        categoryTableView.register(nib, forCellReuseIdentifier: CategoryTableViewCell.identifier)
    }
    func configureTableView() {
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        registerCell()
    }
  
    func configureTextField() {
       
        
    }

    @IBAction func addCategoryButtonAction(_ sender: Any) {
        
        if let title = categoryTextField.text, !title.isEmpty {
            do {
                let duplicate = presenter?.fetchTasks()?.contains(where: { i in
                    i.nameCat == title
                })
                if duplicate == true {
                    self.showAlertOK("Error", "Esta categoria ya existed", "OK", .default, nil)
                } else {
                    try  presenter?.addCategory(titleCategory: title)
                    categoryTableView.reloadData()
                }
            
                print(presenter?.fetchTasks())
            } catch let err {
                print("Categoria no guardada: \(err.localizedDescription)")
            }
        } else {
            print("Categoria no guardada")
        }
        
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension ListCategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        guard let cellCategory: CategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        
        let categories = presenter?.fetchTasks()
        guard let category = categories?[indexPath.row] else { return UITableViewCell() }
        
        cellCategory.styleCell(category)
        cellCategory.selectionStyle = .none
        
        return cellCategory
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
                
            case .none:
                print("none")
            case .delete:
                showAlertTwoOptions("Are you sure you want to delete this note?", "Remove", .destructive, { _ in
                    do {
                        let categories = self.presenter?.fetchTasks()
                        guard let category = categories?[indexPath.row] else { return }
                        try self.presenter?.deleteCategory(category: category)
                        tableView.deleteRows(at: [indexPath], with: .right)
                    } catch let err {
                        print("Error al borrar la tarea: \(err.localizedDescription)")
                    }
                }, "Cancel", .cancel, nil)
            case .insert:
                print("insert")
            
            @unknown default:
                fatalError()
        }
        
        
    }
}
