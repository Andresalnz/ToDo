//
//  EditViewController.swift
//  NotesApp
//
//  Created by Andres Aleu on 18/10/24.
//

import UIKit

class EditNoteViewController: UIViewController {

    @IBOutlet weak var editTaskTextField: UITextField!
    @IBOutlet weak var saveEditButton: UIButton!
    
    var presenter: EditNotePresenter?
    var ui: PresenterUi?
    
    var task: TaskList?
    
    init(task: TaskList?, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.task = task
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView() {
        if let task = task {
            editTaskTextField.text = task.name
        } else {
            //Alerta
            print("Esta vacio")
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func saveEditActionButton(_ sender: Any) {
       
        if let task = task {
            task.name = editTaskTextField.text!
            do {
                
                try presenter?.saveTask()
                
                navigationController?.popViewController(animated: true)
                ui?.update()
            } catch let err {
                print("Error al actualizar: \(err)")
            }
        }
    }
    
}
