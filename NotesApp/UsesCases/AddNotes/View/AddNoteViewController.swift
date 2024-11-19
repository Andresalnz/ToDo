//
//  DetailTaskViewController.swift
//  NotesApp
//
//  Created by Andres Aleu on 17/10/24.
//

import UIKit

class AddNoteViewController: UIViewController {
   
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var presenter: AddNotePresenter?
    var ui: PresenterUi?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar()
        configureTextField()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Keyboard. Scroll TextView
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
          
            descriptionTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            descriptionTextView.scrollIndicatorInsets = descriptionTextView.contentInset
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // Restaurar los insets originales
        descriptionTextView.contentInset = .zero
        descriptionTextView.scrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureTextField() {
        titleTextField.delegate = self
        descriptionTextView.delegate = self
        self.titleTextField.becomeFirstResponder()

    }
    
    @objc func doneButtonAction() {
        do {
            if let title = titleTextField.text, !title.isEmpty, let description = descriptionTextView.text, !description.isEmpty {
                try presenter?.addNote(title: title, descriptionNote: description, date: .now)
                navigationController?.popViewController(animated: true)
               
            } else {
                print("Vacio") //Alerta
            }
            
        } catch let err {
            print("Error en guardar \(err.localizedDescription)")
            //alerta
        }
    }
}

//MARK: - ConfigurationMenuButtonItem
extension AddNoteViewController: ConfigurationMenuButtonItem, ConfigurationNavigationBar {
    func createNavigationBar() {
        title = "New Note"
        createButtonsItem()
    }
    
    func createButtonsItem() {
        var buttonsItem: [UIBarButtonItem] = []
        let buttonShare = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: nil)
        let buttonMenu = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
        let buttonDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        buttonsItem.append(contentsOf: [buttonDone, buttonMenu, buttonShare])
        self.navigationItem.setRightBarButtonItems(buttonsItem, animated: true)

        createAcctionsAndMenu(button: buttonMenu)
    }
    
    func createAcctionsAndMenu(button: UIBarButtonItem) {
        var actions: [UIAction] = []
        let action1 = UIAction(title: "Action 1", image: UIImage(systemName: "star"), handler: { _ in print("1") })
        let action2 = UIAction(title: "Action 1", image: UIImage(systemName: "star"), handler: { _ in print("2") })
        let action3 = UIAction(title: "Action 1", image: UIImage(systemName: "star"), handler: { _ in print("3") })
        actions.append(contentsOf: [action1, action2, action3])
        
        let menu = UIMenu(title: "", options: .destructive, children: actions)
        button.menu = menu
    }
}

//MARK: - UITextFieldDelegate
extension AddNoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please enter a title", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.titleTextField.becomeFirstResponder() }))
            self.navigationController?.present(alert, animated: true, completion: nil)
            return false
        }
        
        textField.resignFirstResponder()
        descriptionTextView.becomeFirstResponder()

        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .systemGray3
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = .clear
    }
}

//MARK: - UITextViewDelegate
extension AddNoteViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        guard let text = titleTextField.text, !text.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please enter a title", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.titleTextField.becomeFirstResponder() }))
            self.navigationController?.present(alert, animated: true, completion: nil)
            
            return false
        }
        
        descriptionTextView.backgroundColor = .systemGray3
        
        return true
    }
    
   
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        descriptionTextView.backgroundColor = .clear
        return true
    }
  
}
