//
//  ComponentsController.swift
//  WebFront
//
//  Created by Vincent Saluzzo on 09/08/2018.
//

import Foundation
import Vapor
import Library

final class ComponentsController: RouteCollection {
    func boot(router: Router) throws {
        let group = router.grouped("components")
        group.get("", use: list)
        group.get("", String.parameter, use: get)
    }
    
    /// Returns a list of all `Todo`s.
    func list(_ req: Request) throws -> [BinaryComponent] {
        var list = [BinaryComponent]()
        for component in App.default.componentManager.components {
            if let bc = BinaryComponent.fromComponent(component) {
                list.append(bc)
            }
        }
        return list
    }
    
    func get(_ req: Request) throws -> BinaryComponent {
        let componentId = try req.parameters.next(String.self)
        let component = App.default.componentManager
            .components
            .filter { $0.componentId ?? "" == componentId }
            .compactMap { component in
                BinaryComponent.fromComponent(component)
            }
            .first
        
        if let c = component {
            return c
        } else {
            throw Abort(.notFound)
        }
    }
}
