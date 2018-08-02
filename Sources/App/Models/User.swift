//
//  User.swift
//  App
//
//  Created by Joshua Coleman on 7/16/18.
//

import FluentSQLite
import Vapor

/// A single entry of a Todo list.
final class User: SQLiteModel {
    
    /// The unique identifier for this `User`.
    var id: Int?
  
    var name: String
    var password: String
    
    /// Creates a new `User`.
    init(id:Int? = nil, name: String, password: String) {
        self.id = id
        self.name = name
        self.password = password
    }
    
    func didCreate(on conn: SQLiteConnection) throws -> EventLoopFuture<User> {
        let userID = id ?? -1
        print("DID CREATE: \(name) - \(userID) ")
        /// Return the user. No async work is being done, so we must create a future manually.
        return Future.map(on: conn) { self }
    }
}

/// Allows `User` to be used as a dynamic migration.
extension User: Migration { }

/// Allows `User` to be encoded to and decoded from HTTP messages.
extension User: Content { }

/// Allows `User` to be used as a dynamic parameter in route definitions.
extension User: Parameter { }
