//
//  Configuration.Webserver.swift
//  WebFront
//
//  Created by Vincent Saluzzo on 09/08/2018.
//

import Foundation
import Library

extension Configuration.Webserver.Credentials {
    var newPayload: Payload {
        return Payload(username: username)
    }
}

extension Configuration.Webserver {
    var bearerSecretData: Data {
        return bearerSecret.data(using: .utf8)!
    }
}
