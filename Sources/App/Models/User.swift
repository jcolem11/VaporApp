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
    
    /// Creates a new `User`.
    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension User: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension User: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension User: Parameter { }
