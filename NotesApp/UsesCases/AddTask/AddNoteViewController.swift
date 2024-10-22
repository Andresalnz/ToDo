//
//  DetailTaskViewController.swift
//  NotesApp
//
//  Created by Andres Aleu on 17/10/24.
//

import UIKit

class AddNoteViewController: UIViewController {
   
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var presenter: AddTaskPresenter?
    var ui: DataProviderUi?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        do {
            if let name = nameTextField.text, !name.isEmpty, let description = descriptionTextField.text, !description.isEmpty {
                try presenter?.addTask(name: nameTextField.text, description: descriptionTextField.text)
                navigationController?.popViewController(animated: true)
                ui?.update()
            } else {
                print("Vacio") //Alerta
            }
           
        } catch let err {
            print("Error en guardar \(err.localizedDescription)")
            //alerta
        }

        
      
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
