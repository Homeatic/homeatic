import Vapor
import Library
/// Creates an instance of Application. This is called from main.swift in the run target.
public func app(_ env: Environment, configuration: Configuration.Webserver) throws -> Application {
    var config = Config.default()
    var env = env
    var services = Services.default()
    try configure(&config, &env, &services, configuration)
    let app = try Application(config: config, environment: env, services: services)
    
    try boot(app)
    return app
}
