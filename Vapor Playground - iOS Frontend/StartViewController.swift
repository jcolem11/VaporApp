//
//  StartViewController.swift
//  HelloPackageDescription
//
//  Created by Joshua Coleman on 3/27/18.
//

import Foundation
import UIKit

public class StartViewController: UIViewController {
    
    @IBOutlet weak var clickMeLabel: UILabel!
    @IBOutlet weak public var textField: UITextField!
    @IBOutlet weak public var scrollView: UIScrollView!
    @IBOutlet weak public var goButton: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        goButton.isEnabled = false
        goButton.addTarget(self, action: #selector(enterChat(_:)), for: .touchUpInside)
        setGoButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @IBAction func enterChat(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "chat") as! ViewController
        let user = User(name: textField.text!, tag: "Its me")
        present(vc, animated: true) {
            vc.user = user
        }
    }
    
    private func setGoButton(){
        if goButton.isEnabled{
            goButton.setTitle("😁", for: .normal)
            goButton.alpha = 1.0
            clickMeLabel.isHidden = false
        }else{
            goButton.setTitle("👿", for: .normal)
            goButton.alpha = 0.4
            clickMeLabel.isHidden = true
        }
    }
}

extension StartViewController: UITextFieldDelegate{
    //TODO: Set character limit
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text{
            goButton.isEnabled = text.count <= 20 && text.count > 1
        }
        setGoButton()
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
