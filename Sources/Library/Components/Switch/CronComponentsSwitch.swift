//
//  CronComponentsSwitch.swift
//  Homeatic
//
//  Created by Vincent Saluzzo on 06/08/2018.
//

import Foundation
import RxSwift

class CronComponentsSwitch: Switch {
    var platform: Platforms.Type { return CronComponents.self }
    
    var localIdentifier: Any
    var componentId: String?
    var state = BehaviorSubject<Bool>(value: false)
    
    var startDate = Date()
    init(withConfiguration config: CronComponents.Configuration.ComponentConfiguration, withComponentId cId: String?) throws {
        localIdentifier = config.identifier
        componentId = cId
        DispatchQueue.global(qos: .utility).async { [unowned self] in
            while true {
                Thread.sleep(forTimeInterval: Double(config.seconds))
                self.state.onNext(!(try! self.state.value()))
            }
        }
        
    }
}
