//
//  ChatMessage.swift
//  HelloPackageDescription
//
//  Created by Joshua Coleman on 3/27/18.
//

import Foundation

struct ChatMessage {
    var sender : String
    var text : String
    var json: Data?{
        do{
            return try JSONSerialization.data(withJSONObject: ["sender": sender, "text" : text], options: .prettyPrinted)
        }catch{
            print("json conversion failed")
        }
        return nil
    }
}

extension ChatMessage{
    init(dict: [String: String]){
        self.init(
            sender: dict["sender"] ?? "??",
            text: dict["text"] ?? ""
        )
    }
}
