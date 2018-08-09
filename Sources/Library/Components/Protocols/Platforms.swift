//
//  Platforms.swift
//  Homeatic
//
//  Created by Vincent Saluzzo on 05/08/2018.
//

import Foundation
import RxSwift

public protocol Platforms {
    static func initializingWith(configuration: [String: Any], componentManager: ComponentManager) -> Observable<Platforms>
    static var configurationEntryName: String { get }
}

enum PlatformsError: Swift.Error {
    case badConfiguration(Error?)
    case registryError
}


struct Platform {
    private init() { }
    static var supportedPlatforms: [Platforms.Type] {
        return [
            CronComponents.self
        ]
    }
}
