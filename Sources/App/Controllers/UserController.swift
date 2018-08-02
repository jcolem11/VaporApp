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
    
    
    func test(_ req: Request) throws -> String{
        return "Hello, World"
    }
    
    func login(_ req: Request) throws -> Future<View> {
        let leaf = try req.make(LeafRenderer.self)
        let dummyContext = [String:String]()
        
        /* https://docs.vapor.codes/3.0/vapor/content/#decode */
        
        return try req.content.decode(User.self).flatMap(to: View.self) { user in
            User.query(on: req).filter(\User.name == user.name).filter(\User.password == user.password).first().flatMap(to: View.self) { user in
                guard let user = user else{ throw Abort(.notFound) }
                return leaf.render("login", user)
            }}.catchFlatMap({ (error) -> (EventLoopFuture<View>) in
                return leaf.render("login", dummyContext)
            })
    }
    
    func getAll(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
}
