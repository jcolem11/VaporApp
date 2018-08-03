//
//  UserController.swift
//  App
//
//  Created by Joshua Coleman on 7/16/18.
//

import Foundation
import Vapor
import Leaf
import Fluent

//Custom HTTP Content: Login request content


final class UserController {
    
    let dummyContext = [String:String]()
    
    func test(_ req: Request) throws -> String{
        return "Hello, World"
    }
    
    func register(_ req: Request) throws -> Future<View>{
        let leaf = try req.make(LeafRenderer.self)
        
        return try req.content.decode(User.self).flatMap(to:View.self){ reqUser in
            let newUser: User = User(name: reqUser.name, password: reqUser.password)
            newUser.create(on: req).always {
                print("USER SUCCESSFULLY CREATED")
            }
            
            return try self.getAll(req).flatMap(to:View.self){ users in
                return leaf.render("getall", ["users" : users])
            }
        }
    }
    
    func login(_ req: Request) throws -> Future<View> {
        let leaf = try req.make(LeafRenderer.self)
        
        /* https://docs.vapor.codes/3.0/vapor/content/#decode */
        
        return try req.content.decode(User.self).flatMap(to: View.self) { user in
            User.query(on: req).filter(\User.name == user.name).filter(\User.password == user.password).first().flatMap(to: View.self) { user in
                guard let _ = user else{ throw Abort(.notFound) }
//                req.redirect(to: <#T##String#>)
                return try self.getAll(req).flatMap(to:View.self){ users in
                    return leaf.render("getall", ["users" : users])
                }
            }}.catchFlatMap({ (error) -> (EventLoopFuture<View>) in
                print("LOGIN FAILED")
                return leaf.render("register", self.dummyContext)
            })
    }
    
    func getAll(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
}
