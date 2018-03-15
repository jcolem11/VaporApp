import Vapor


extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("plaintext") { req in
            return "Hello, world!"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        //MARK: Custom Controllers to handle requests
        
        let pokeController = PokeAPIController(drop: self)
        get("poke", handler: pokeController.getPokemon)
        
        try resource("posts", PostController.self)
    }
}
