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
    
    static let CellID = "cell"
    static let LocalWebSocketURLString = "ws://localhost:8080/chatroom"
    static let RemoteWebSocketURLString = "ws://possible-develop.vapor.cloud/chatroom"
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var contentBottom: NSLayoutConstraint!
    
    var contentToKeyBoardConstraint: NSLayoutConstraint?
    var socket = WebSocket(url:URL(string:ViewController.LocalWebSocketURLString)!)
    var user : User!
    var messages: [ChatMessage] = [ChatMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
       
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
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
        
        let m = ChatMessage(sender: user.name, text: text)
        
        if let json = m.json{
            socket.write(data: json)
        }
        
        textField.text = nil
        return true
    }
    
}

extension UIViewController{
    func presentNotification(withMessage message: NotificationMessage){
        
        self.presentNotification(withMessage: message){
            for view in self.view.subviews{
                guard let nv = view as? NotificationView else {
                    continue
                }
                self.dismissNotificationView(nv)
            }
        }
    }
    
    func presentNotification(withMessage message: NotificationMessage, handler tapHandler: @escaping NotificationViewTapHandler){
        let nv = NotificationView(notificationMessage: message)
        
        nv.tapHandler = tapHandler
        
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
        let message = NotificationMessage(title: "WebSocket Connection Successful", content: "tap to close")
        presentNotification(withMessage: message)
        print("SOCKET CONNECTION SUCCESSFUL")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        let message = NotificationMessage(title: "WebSocket Disconnected", content: "tap to attempt reconnection")
        presentNotification(withMessage: message){
            self.socket.connect()
        }
        print("SOCKET DISCONNECTED")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let message = NotificationMessage(title: "Message received:", content: text)
        presentNotification(withMessage: message)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        do{
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: String]{
                let message = ChatMessage(dict: json)
                messages.append(message)
                tableView.beginUpdates()
                //TODO: Reloading shouldnt be necessary, but for some reason insertRows() causes strange layout issues
                tableView.reloadData()
                tableView.insertRows(at: [IndexPath(row: messages.count-1, section: 0)], with: .fade)
                tableView.endUpdates()
                tableView.scrollToRow(at: IndexPath(row: messages.count-1, section: 0), at: .bottom, animated: true)
            }
        }catch{
            print("json error: \(error.localizedDescription)")
        }
        print("SOCKET RECEIVED DATA:\n")
    }
}

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.CellID, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.row]
        cell.configureWith(message)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ViewController: KeyboardPresenting{
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
           
            let height = keyboardSize.height
           
            contentBottom.isActive = false
            
            let new = contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -height)
           
            new.isActive = true
            contentToKeyBoardConstraint = new
            
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        contentToKeyBoardConstraint?.isActive = false
        contentBottom.isActive = true
        view.layoutIfNeeded()
    }
}



