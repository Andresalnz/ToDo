//
//  DetailTaskViewController.swift
//  NotesApp
//
//  Created by Andres Aleu on 17/10/24.
//

import UIKit

class AddAndEditNoteViewController: UIViewController {
   
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var presenter: AddAndEditNotePresenter?
    var ui: PresenterUi?
    
    let optionsRoute: OptionsRoute
    
    let note: ListNotes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar()
        configureView()
        observerKeyBoard()
        actionBackButton()
    }
    
    init(note: ListNotes? = nil, optionsRoute: OptionsRoute, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.note = note
        self.optionsRoute = optionsRoute
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Back Button
    func actionBackButton() {
        self.navigationController?.topViewController?.navigationItem.backAction = UIAction(title: "", state: .mixed, handler: { _ in
            if self.titleTextField.text?.isEmpty == true {
                self.navigationController?.popViewController(animated: true)
                self.showAlertOK("Error", "Please enter a title, was not saved", "OK", .default, {_ in self.titleTextField.becomeFirstResponder()})
            } else {
                self.doneButtonAction()
            }
        })
    }
    
    //MARK: - Keyboard. Scroll TextView
    func observerKeyBoard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
    }

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
    
    func configureView() {
        titleTextField.delegate = self
        descriptionTextView.delegate = self
        self.titleTextField.becomeFirstResponder()
        style()
    }
    
//MARK: - Styles
    func style() {
        
        stackView.spacing = 10
        
        switch optionsRoute {
            case .add :
                titleTextField.configureStyleTextField("Title", nil, .RobotoRegular, .none, autoCapitalization: .sentences)
                descriptionTextView.configureStyleTextView("Description", .RobotoLight, .lightGray, autoCapitalization: .sentences)
                
            case .edit(let editNote):
                if let title = editNote.title, let descriptionNote = editNote.descriptionNote {
                    titleTextField.configureStyleTextField(nil, title, .RobotoRegular, .none, autoCapitalization: .sentences)
                    if descriptionNote.isEmpty {
                        descriptionTextView.configureStyleTextView("Description", .RobotoLight, .lightGray, autoCapitalization: .sentences)
                    } else {
                        descriptionTextView.configureStyleTextView(descriptionNote, .RobotoLight, .black, autoCapitalization: .sentences)
                    }
                }
        }
    }
    
    func navigationOptionsNote(_ optionsActions: OptionsActionsAddEditOrDelete) {
        switch optionsActions {
            case .add :
                do {
                    if descriptionTextView.textColor == .lightGray {
                        descriptionTextView.text = ""
                    }
                    
                    if let title = titleTextField.text, !title.isEmpty, let description = descriptionTextView.text {
                        try presenter?.addNote(title: title, descriptionNote: description, date: .now)
                        navigationController?.popViewController(animated: true)
                        ui?.update()
                    } else {
                        showAlertOK("Error", "Please enter a title", "OK", .default, {_ in self.titleTextField.becomeFirstResponder()})
                    }
                } catch {
                    showAlertOK("Error", "Please enter a title", "OK", .default, {_ in self.titleTextField.becomeFirstResponder()})
                }
                
            case .edit(let editNote):
                do {
                    guard let title = titleTextField.text, !title.isEmpty else {
                        showAlertOK("Error", "Please enter a title", "OK", .default, {_ in self.titleTextField.becomeFirstResponder()})
                        return
                    }
                    if descriptionTextView.textColor != .lightGray {
                        try presenter?.editNote(title: titleTextField.text, descriptionNote: descriptionTextView.text, date: .now, note: editNote, {
                            self.navigationController?.popViewController(animated: true)
                            self.ui?.update()
                        })
                    } else {
                        try  presenter?.editNote(title: titleTextField.text, descriptionNote: nil, date: .now, note: editNote, {
                            self.navigationController?.popViewController(animated: true)
                            self.ui?.update()
                        })
                    }
                } catch {
                    showAlertOK("Error", "Not updated", "OK", .default, {_ in self.titleTextField.becomeFirstResponder()})
                }
            case .delete(let deleteNote):
                deleteAction()
        }
    }
    
    @objc func doneButtonAction() {
        switch optionsRoute {
            case .edit(let editNote):
                navigationOptionsNote(.edit(editNote))
            case .add:
                navigationOptionsNote(.add)
        }
    }
    
    func deleteAction() {
        do {
            if let note = note {
                try presenter?.deleteTask(idNote: note)
            }
            navigationController?.popViewController(animated: true)
        } catch  {
            print("no ha borrado")
        }
       
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

//MARK: - ConfigurationMenuButtonItem
extension AddAndEditNoteViewController: ConfigurationMenuButtonItem, ConfigurationNavigationBar {
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
        let imageTrash = UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        let action1 = UIAction(title: "Action 1", image: UIImage(systemName: "star"), handler: { _ in print("1099") })
        let action2 = UIAction(title: "Action 1", image: UIImage(systemName: "star"), handler: { _ in print("2") })
        let action3 = UIAction(title: "Delete", image: imageTrash, handler: { _ in
            if let note = self.note {
                self.navigationOptionsNote(.delete(note))
            }
        })
        
        actions.append(contentsOf: [action1, action2, action3])
        
        let menu = UIMenu(title: "", options: .destructive, children: actions)
        button.menu = menu
    }
}

//MARK: - UITextFieldDelegate
extension AddAndEditNoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            showAlertOK("Error", "Please enter a title", "OK", .default, {_ in self.titleTextField.becomeFirstResponder()})
            return false
        }
        
        textField.resignFirstResponder()
        descriptionTextView.becomeFirstResponder()

        return true
    }
}

//MARK: - UITextViewDelegate
extension AddAndEditNoteViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        guard let text = titleTextField.text, !text.isEmpty else {
            showAlertOK("Error", "Please enter a title", "OK", .default, {_ in self.titleTextField.becomeFirstResponder()})
            
            return false
        }
        if textView.textColor == .lightGray {
            descriptionTextView.text = nil
            descriptionTextView.textColor = .black
        }
        return true
    }
  
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Description"
            descriptionTextView.textColor = .lightGray
        }
    }
}
