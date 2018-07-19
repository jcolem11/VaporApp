//
//  UserController.swift
//  App
//
//  Created by Joshua Coleman on 7/16/18.
//

import Foundation
import Vapor
import Leaf

//Custom HTTP Content: Login request content


final class UserController {
    
    func test(_ req: Request) throws -> String{
        return "Hello, World"
    }
    
    func login(_ req: Request) throws -> Future<String> {
        /* https://docs.vapor.codes/3.0/vapor/content/#decode */
    
        return try req.content.decode(User.self).map{ user in
            print("\(user.name) logged in")
            return "Hello, \(user.name)"
        }
    }
    
    func getAll(_ req: Request) throws -> Future<View> {
        let leaf = try req.make(LeafRenderer.self)
        let user = User(name: "Bob")
        return leaf.render("getall", user)
    }

}
