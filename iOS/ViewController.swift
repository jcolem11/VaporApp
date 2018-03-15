//
//  ViewController.swift
//  VaporApp
//
//  Created by Joshua Coleman on 3/12/18.
//

import UIKit 
import Starscream


class ViewController: UIViewController{
    
    static let WebSocketURLString = "ws://localhost:8080/chat"
    @IBOutlet weak var textfield: UITextField!
    var socket = WebSocket(url:URL(string:ViewController.WebSocketURLString)!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        socket.write(string: text)
        textField.text = nil
        return true
    }
    
}

extension UIViewController{
    func presentNotification(withMessage message: NotificationMessage){
        let nv = NotificationView(notificationMessage: message)
        nv.tapHandler = { nv.removeFromSuperview() }
        view.addSubview(nv)
        view.bringSubview(toFront: nv)
        nv.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        let offsetConstraint = nv.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -300.00)
        let actualConstraint = nv.topAnchor.constraint(equalTo: self.view.topAnchor)
        offsetConstraint.isActive = true
        self.view.layoutIfNeeded()
        
        //TODO: Separate this
        UIView.animate(withDuration: 0.5 , animations: {
            offsetConstraint.isActive = false
            actualConstraint.isActive = true
            self.view.layoutIfNeeded()
        }) { (complete) in
            
        }
    }
}

extension ViewController: WebSocketDelegate{
    
    func websocketDidConnect(socket: WebSocketClient) {
        let message = NotificationMessage(title: "Socket Connection:", content: "Successful")
        presentNotification(withMessage: message)
        print("SOCKET CONNECTION SUCCESSFUL")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("SOCKET DISCONNECTED")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("SOCKET RECEIVED MESSAGE:\(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("SOCKET RECEIVED DATA")
    }
}

