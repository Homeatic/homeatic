//
//  AuthenticationController.swift
//  WebFront
//
//  Created by Vincent Saluzzo on 09/08/2018.
//

import Foundation
import Vapor
import Library
import JWT

final class AuthenticationController: RouteCollection {
    
    let configuration: Configuration.Webserver
    init(_ configuration: Configuration.Webserver) {
        self.configuration = configuration
    }
    
    func boot(router: Router) throws {
        let group = router.grouped("auth")
        group.post("auth", use: auth)
    }
    
    func auth(_ request: Request) throws -> Future<BearerToken> {
        let credentials = configuration.credentials
        guard let basicAuthorization = request.http.headers.basicAuthorization else {
            throw Abort(.badRequest, reason: "Basic authorization missing")
        }
        
        guard basicAuthorization.password == credentials.password && basicAuthorization.username == credentials.username else {
            throw Abort(.forbidden, reason: "Wrong credentials")
        }
        
        var jwt = JWT<Payload>(payload: configuration.credentials.newPayload)
        let tokenData = try jwt.sign(using: .hs256(key: configuration.bearerSecretData))
        let token = String(data: tokenData, encoding: .utf8)!
        return BearerToken(token)
            .save(on: request)
            .map {
                var a = $0; a.id = nil
                return $0
        }
    }
}
