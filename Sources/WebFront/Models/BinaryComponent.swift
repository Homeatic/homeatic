//
//  Component.swift
//  WebFront
//
//  Created by Vincent Saluzzo on 07/08/2018.
//

import Foundation
import Vapor
import Library

struct BinaryComponent: Content {
    var id: String
    var isOn: Bool
    
    init?(_ light: Light) {
        guard let id = light.componentId else { return nil }
        self.id = id
        self.isOn = light.isOn
    }
    
    init?(_ binarySensor: BinarySensor) {
        guard let id = binarySensor.componentId,
            let isOn = try? binarySensor.isOn.value()
            else { return nil }
        self.id = id
        self.isOn = isOn
    }
    
    init?(_ switch: Switch) {
        guard let id = `switch`.componentId,
            let isOn = try? `switch`.state.value()
            else { return nil }
        self.id = id
        self.isOn = isOn
    }
}

extension BinaryComponent {
    
    static func fromComponent(_ component: Component) -> BinaryComponent? {
        if let comp = component as? BinarySensor, let binaryComp = BinaryComponent(comp) {
            return binaryComp
            
        } else if let comp = component as? Switch, let binaryComp = BinaryComponent(comp) {
            return binaryComp
            
        } else if let comp = component as? Light, let binaryComp = BinaryComponent(comp) {
            return binaryComp
        }
        
        return nil
    }
    
}
