import FluentSQLite
import Vapor
//import VaporRequestStorage
//import JWTMiddleware
import Authentication
import Library

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services, _ configurationDetail: Configuration.Webserver) throws {
    
    /// Register providers first
    try services.register(FluentSQLiteProvider())
    try services.register(AuthenticationProvider())
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router, configurationDetail)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    let sqlite = try SQLiteDatabase(storage: .memory)

    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: BearerToken.self, database: .sqlite)
    services.register(migrations)
    
//    WebSocket Example
//    let wss = NIOWebSocketServer.default()
//    wss.get("echo") { (ws, req) in
//        ws.onText({ (ws, text) in
//            ws.send(text)
//        })
//    }
//    services.register(wss, as: WebSocketServer.self)

}
