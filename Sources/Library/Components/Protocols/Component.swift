//
//  Component.swift
//  Homeatic
//
//  Created by Vincent Saluzzo on 05/08/2018.
//

import Foundation

public protocol Component: class {
    var componentId: String? { get set }
    var platform: Platforms.Type { get }
    var localIdentifier: Any { get set }
}
