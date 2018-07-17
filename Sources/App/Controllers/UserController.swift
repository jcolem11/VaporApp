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
    func getAll(_ req: Request) throws -> Future<View> {
        let leaf = try req.make(LeafRenderer.self)
        let context = [String: String]()
        return try leaf.render("home", context)
    }
    
//    func createUser(_ req: Request) throws -> Future<User> {
//        Save to SQLite
//    }
}
