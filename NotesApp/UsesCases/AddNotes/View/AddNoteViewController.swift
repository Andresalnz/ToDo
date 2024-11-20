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
        configureView()
        observerKeyBoard()
        actionBackButton()
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
        //StackView
        stackView.spacing = 10
        
        //TextField
        titleTextField.configureStyleTextField("Title", .RobotoRegular, .none, autoCapitalization: .sentences)
        
        //TextView
        descriptionTextView.configureStyleTextView("Description", .RobotoLight, .lightGray, autoCapitalization: .sentences)
    }
    
    @objc func doneButtonAction() {
        do {
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
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            showAlertOK("Error", "Please enter a title", "OK", .default, {_ in self.titleTextField.becomeFirstResponder()})
            return false
        }
        
        textField.resignFirstResponder()
        descriptionTextView.becomeFirstResponder()

        return true
    }
}

//MARK: - UITextViewDelegate
extension AddNoteViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        guard let text = titleTextField.text, !text.isEmpty else {
            showAlertOK("Error", "Please enter a title", "OK", .default, {_ in self.titleTextField.becomeFirstResponder()})
            
            return false
        }
        descriptionTextView.text = nil
        descriptionTextView.textColor = .black
        return true
    }
  
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Description"
            descriptionTextView.textColor = .lightGray
        }
    }
}
