import Vapor
import Leaf

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    // Test
    router.get("home") { req -> Future<View> in
        let leaf = try req.make(LeafRenderer.self)
        let dummyContext = [String:String]()
        return leaf.render("login", dummyContext)
    }
    
    // User interactions
    let userController = UserController()
    router.get("users","all", use: userController.getAll)
    router.get("test", use: userController.test)
    router.post("login", use:userController.login)

    
    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
    
}
