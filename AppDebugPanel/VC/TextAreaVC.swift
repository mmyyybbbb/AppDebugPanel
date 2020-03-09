//
//  AppDebugEditMockVC.swift
//  MyBroker
//
//  Created by Alexej Nenastev on 01.09.2018.
//  Copyright © 2018 BCS. All rights reserved.
//

import UIKit

protocol TextAreaVCDelegate: class {
    func textUpdated(str:String)
}

final class TextAreaVC: UIViewController {

    @IBOutlet weak var fastForwardButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
 
    private var stringData: String!

    private var onSave:  Handler<String>!

    @IBAction func save(_ sender: Any) {
        onSave(textView.text)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func saveAndClose(_ sender: Any) {
        onSave(textView.text)
        dismiss(animated: true, completion: nil)
    }
    
    static func instantiate(text: String, onSave: @escaping Handler<String>) -> TextAreaVC {
        
        let vc = UIStoryboard(name: "TextAreaVC", bundle: Bundle.init(for: TextAreaVC.self)).instantiateViewController(withIdentifier: "TextAreaVC") as! TextAreaVC
        vc.stringData = text
        vc.onSave = onSave
        return vc
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        textView.text = stringData
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:  UIResponder.keyboardWillHideNotification, object: nil)
         
        let toolbar = KeyboardDoneToolbar(
            target: self,
            action: #selector(doneButtonAction)
        )
        
        textView.inputAccessoryView = toolbar
        textView.inputAccessoryView?.autoresizingMask = .flexibleHeight
    }

    @objc private func doneButtonAction() {
        view.endEditing(true)
    }
    @IBAction func copyText(_ sender: Any) {
        UIPasteboard.general.string = textView.text
    }

    @IBAction func pastReplace(_ sender: Any) {
        textView.text = UIPasteboard.general.string
    }

    @objc func keyboardWillShow(notification: NSNotification) {

        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = self.textView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        self.textView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification: NSNotification) {

        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        self.textView.contentInset = contentInset
    }
}

final class KeyboardDoneToolbar: UIToolbar {
    
    private let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private var doneButton = UIBarButtonItem()
    
    init(target: Any?, action: Selector?) {
        super.init(frame: .zero)
        
        doneButton = UIBarButtonItem(title: "Готово", style: .done, target: target, action: action)
        
        backgroundColor = .white
        isTranslucent = false
        items = [flexibleButton, doneButton]
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
