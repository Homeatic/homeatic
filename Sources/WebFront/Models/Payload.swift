//
//  Payload.swift
//  WebFront
//
//  Created by Vincent Saluzzo on 07/08/2018.
//

import Foundation
import JWT
import JWTMiddleware

/// A representation of the payload used in the access tokens
/// for this service's authentication.
struct Payload: JWTPayload {
    let exp: TimeInterval
    let iat: TimeInterval
    
    // These two are to be customized according to what is in the JWT
    let username: String
    
    
    func verify() throws {
        let expiration = Date(timeIntervalSince1970: self.exp)
        try ExpirationClaim(value: expiration).verify()
    }
    
    init(username: String) {
        exp = Date().addingTimeInterval(60).timeIntervalSince1970
        iat = 0
        self.username = username
    }
}


