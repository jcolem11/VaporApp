//
//  StartViewController.swift
//  HelloPackageDescription
//
//  Created by Joshua Coleman on 3/27/18.
//

import Foundation
import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var goButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        goButton.isEnabled = false
        
        setGoButton()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @IBAction func enterChat(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "chat")
        present(vc, animated: true, completion: nil)
    }
    
    private func setGoButton(){
        if goButton.isEnabled{
            goButton.setTitle("😁", for: .normal)
            goButton.alpha = 1.0
        }else{
            goButton.setTitle("👿", for: .normal)
            goButton.alpha = 0.4
        }
    }
}

extension StartViewController: UITextFieldDelegate{
    //TODO: Set character limit
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text{
            goButton.isEnabled = text.count <= 20 && text.count > 1
        }
        setGoButton()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension StartViewController: KeyboardPresenting{
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
}
