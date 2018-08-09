//
//  Router+BearerToken.swift
//  WebFront
//
//  Created by Vincent Saluzzo on 09/08/2018.
//

import Foundation
import Library
import JWT
import Authentication

extension Router {
    func bearerSecurizedRoute(withConfiguration configuration: Configuration.Webserver) -> Router {
        return self.grouped(BearerAuthenticationMiddleware<BearerToken>())
            .grouped { (request, responder) -> EventLoopFuture<Response> in
                do {
                    let token = try request.requireAuthenticated(BearerToken.self)
                    let jwt = try JWT<Payload>.init(from: token.bearerToken.data(using: .utf8)!,
                                                    verifiedUsing: .hs256(key: configuration.bearerSecretData))
                    if jwt.payload.username == configuration.credentials.username {
                        return try responder.respond(to: request)
                    } else {
                        throw Abort(.unauthorized, reason: "Wrong identity")
                    }
                } catch {
                    if let authenticationError = error as? AuthenticationError, authenticationError.identifier == "notAuthenticated" {
                        throw Abort(.unauthorized, reason: "Missing Bearer token")
                    }
                    if let jwtError = error as? JWTError, jwtError.identifier == "exp" {
                        throw Abort(.unauthorized, reason: "Token expired, please create a new token.")
                    } else {
                        throw error
                    }
                }
        }
    }
}
