//
//  CronComponentsBinarySensor.swift
//  Homeatic
//
//  Created by Vincent Saluzzo on 06/08/2018.
//

import Foundation
import RxSwift

class CronComponentsBinarySensor: Component, BinarySensor {
    var localIdentifier: Any
    var componentId: String?
    var platform: Platforms.Type { return CronComponents.self }
    
    var isOn = BehaviorSubject<Bool>(value: false)
    
    init(withConfiguration config: CronComponents.Configuration.ComponentConfiguration, withComponentId cId: String?) throws {
        localIdentifier = config.identifier
        componentId = cId
        DispatchQueue.global(qos: .utility).async { [unowned self] in
            while true {
                Thread.sleep(forTimeInterval: Double(config.seconds))
                self.isOn.onNext(!(try! self.isOn.value()))
            }
        }
    }
}
