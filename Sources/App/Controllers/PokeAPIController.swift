//
//  PokeAPIController.swift
//  HelloPackageDescription
//
//  Created by Joshua Coleman on 3/12/18.
//

import Vapor
import HTTP

// A basic controller that does not implement ResourceRepresentable protocol

final class PokeAPIController{
    //TODO: Could Middleware be used for this?
    
    //TODO: Need a reference to a Droplet as calling try Droplet() more than once causes strange behavior
    let drop: Droplet
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func getPokemon(_ req: Request) throws -> ResponseRepresentable {
        
        guard let ID = req.query?["id"]?.int else {
            throw Abort(.badRequest)
        }

        let res = try drop.client.get("https://pokeapi.co/api/v2/pokemon/\(ID)/")
        guard let json = res.json, let name = json["name"]?.string else{
            return "???"
        }
        return "You chose: \(name)"
        
    }
}
