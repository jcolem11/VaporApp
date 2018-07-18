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
    
    func getAll(_ req: Request) throws -> Future<View> {
        let leaf = try req.make(LeafRenderer.self)
        let user = User(name: "Bob")
        return leaf.render("getall", user)
    }

}
