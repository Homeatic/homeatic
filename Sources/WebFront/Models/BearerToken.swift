//
//  BearerToken.swift
//  WebFront
//
//  Created by Vincent Saluzzo on 09/08/2018.
//

import Foundation
import FluentSQLite
import Authentication

struct BearerToken: Codable, Content {
    var token: String
    var id: Int?
    
    init(_ token: String) {
        self.token = token
    }
}

extension BearerToken: SQLiteModel { }

extension BearerToken: BearerAuthenticatable {
    static var tokenKey = \BearerToken.token
}

extension BearerToken: Migration { }
