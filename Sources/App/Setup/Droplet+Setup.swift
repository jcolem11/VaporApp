@_exported import Vapor

extension Droplet {
    public func setup() throws {
        try setupRoutes()
        
        //create websocket
        self.socket("chat") { req, socket in
            print("New WebSocket connected: \(socket)")
            
            // ping the socket to keep it open
            try background {
                while socket.state == .open {
                    try? socket.ping()
                    self.console.wait(seconds: 10) // every 10 seconds
                }
            }
            
            socket.onText = { socket, text in
                print("Text received: \(text)")
                
                // reverse the characters and send back
                let rev = String(text.reversed())
                try socket.send(rev)
            }
            
            
            socket.onClose = { socket, code, reason, clean in
                print("Closed.")
            }
        }

        
    }
}
