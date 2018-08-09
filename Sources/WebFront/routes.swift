import Vapor
//import JWTMiddleware
import Authentication
import JWT
import FluentSQLite
import Library

/// Register your application's routes here.
public func routes(_ router: Router, _ configuration: Configuration.Webserver) throws {
    
    let apiGroup = router.grouped("api")
    try apiGroup.register(collection: AuthenticationController(configuration))
    let bearerSecurizedGroup = apiGroup.bearerSecurizedRoute(withConfiguration: configuration)
    try bearerSecurizedGroup.register(collection: ComponentsController())
    
}


