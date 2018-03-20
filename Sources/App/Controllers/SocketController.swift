//
//  SocketController.swift
//  HelloPackageDescription
//
//  Created by Joshua Coleman on 3/20/18.
//

import Foundation
import Vapor
import HTTP

// A basic controller that does not implement ResourceRepresentable protocol

final class SocketController{
    
    let drop: Droplet
    
    var socketConnections = [WebSocket]()
    
    init(drop: Droplet) {
        self.drop = drop
        setupSocket()
    }
    
    func setupSocket(){
        //This method upgrades reqeuest to WebSocket connection
        drop.socket("chat") { (req, socket) in
            self.socketConnections.append(socket)
            
            try background {
                while socket.state == .open {
                    try? socket.ping()
                    self.drop.console.wait(seconds: 10) // every 10 seconds
                }
            }
            
            socket.onText = { socket, text in
                for s in self.socketConnections{
                    try s.send(text)
                }
            }
            
            
            socket.onClose = { socket, code, reason, clean in
                print("Server closed socket connection.....")
            }
            
        }
    }

}
