//
//  SocketController.swift
//  HelloPackageDescription
//
//  Created by Joshua Coleman on 3/20/18.
//

import Foundation
import Vapor
import HTTP


final class SocketController{
    
    typealias ClientSocket = (userID:String, socket:WebSocket)
    let drop: Droplet
    
    var socketConnections = [ClientSocket]()
    
    init(drop: Droplet) {
        self.drop = drop
        setupSocket()
    }
    
    func setupSocket(){
        //This method upgrades reqeuest to WebSocket connection
        drop.socket("chat") { (req, socket) in
            
            let id = String( Int.random(min: 1, max: 99) )
            let newClient = ClientSocket(id, socket)
            
            self.socketConnections.append(newClient)
            
            try background {
                while socket.state == .open {
                    try? socket.ping()
                    self.drop.console.wait(seconds: 10) // every 10 seconds
                }
            }
            
            socket.onText = { socket, text in
                for s in self.socketConnections{
                    if (s.socket !== socket){
                        try s.socket.send(text)
                    }
                }
                
            }
            
            //TODO: Needs much work
            socket.onBinary = { socket, data in
                for s in self.socketConnections{
                    do{
                        try s.socket.send(data)
                    } catch let error {
                        //Send error only to sender
                        print(error)
                    }
                }
            }
            
            socket.onClose = { socket, code, reason, clean in
                print("Server closed socket connection.....reason:\n")
                if let reason = reason{ print(reason) }
            }
            
        }
    }
    
}
