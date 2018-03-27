//
//  ViewController.swift
//  VaporApp
//
//  Created by Joshua Coleman on 3/12/18.
//

import UIKit 
import Starscream

protocol KeyboardPresenting {
    func keyboardWillShow(_ notification: Notification)
    func keyboardWillHide(_ notification: Notification)
}
class ViewController: UIViewController{
    
    static let LocalWebSocketURLString = "ws://localhost:8080/chat"
    static let RemoteWebSocketURLString = "ws://possible-develop.vapor.cloud/chat"
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var socket = WebSocket(url:URL(string:ViewController.LocalWebSocketURLString)!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        textfield.delegate = self
        socket.delegate = self
        socket.connect()
        
    }
    
}

extension ViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textfield.text, text.count > 0 else {
            textfield.resignFirstResponder()
            return true
        }
        
        let m = ChatMessage(sender: "me", text: text)
        
        if let json = m.json{
            socket.write(data: json)
        }
        
        textField.text = nil
        return true
    }
    
}

extension UIViewController{
    
    func presentNotification(withMessage message: NotificationMessage){
        let nv = NotificationView(notificationMessage: message)
        
        nv.tapHandler = {
            self.dismissNotificationView(nv)
        }
        
        view.addSubview(nv)
        view.bringSubview(toFront: nv)
        nv.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        let offsetConstraint = nv.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -300.00)
        let actualConstraint = nv.topAnchor.constraint(equalTo: self.view.topAnchor)
        offsetConstraint.isActive = true
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5 , animations: {
            offsetConstraint.isActive = false
            actualConstraint.isActive = true
            self.view.layoutIfNeeded()
        })
    }
    
    func dismissNotificationView(_ notificationView:NotificationView){
        let offsetConstraint = notificationView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -300.00)
        
        UIView.animate(withDuration: 0.2, animations: {
            offsetConstraint.isActive = true
            self.view.layoutIfNeeded()
        }) { (val) in
            notificationView.removeFromSuperview()
        }
    }
    
}

extension ViewController: WebSocketDelegate{
    
    func websocketDidConnect(socket: WebSocketClient) {
        let message = NotificationMessage(title: "WebSocket:", content: "Connection Successful")
        presentNotification(withMessage: message)
        print("SOCKET CONNECTION SUCCESSFUL")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        let message = NotificationMessage(title: "WebSocket:", content: "Disconnected")
        presentNotification(withMessage: message)
        print("SOCKET DISCONNECTED; Reconnecting")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let message = NotificationMessage(title: "Message received:", content: text)
        presentNotification(withMessage: message)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        do{
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: String]{
                let message = ChatMessage(dict: json)
                let notification = NotificationMessage(title: message.sender, content: message.text)
                presentNotification(withMessage: notification)
            }
        }catch{
            print("json error: \(error.localizedDescription)")
        }
        print("SOCKET RECEIVED DATA:\n")
    }
}

extension ViewController: KeyboardPresenting{
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
}



