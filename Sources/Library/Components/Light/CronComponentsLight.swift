//
//  CronComponentsLight.swift
//  Homeatic
//
//  Created by Vincent Saluzzo on 06/08/2018.
//

import Foundation
import RxSwift

class CronComponentsLight: Light {
    var localIdentifier: Any
    var componentId: String?
    var platform: Platforms.Type { return CronComponents.self }
    
    var isOnObservable: Observable<Bool> { return _isOn.asObservable() }
    var isOn: Bool { return (try? _isOn.value()) ?? false }
    private var _isOn = BehaviorSubject<Bool>(value: false)
    
    func turnOn() -> Observable<Void> {
        _isOn.onNext(true)
        return .just(())
    }
    
    func turnOff() -> Observable<Void> {
        _isOn.onNext(false)
        return .just(())
    }
    
    var startDate = Date()
    init(withConfiguration config: CronComponents.Configuration.ComponentConfiguration, withComponentId cId: String?) throws {
        localIdentifier = config.identifier
        componentId = cId
        var turnOn = true
        DispatchQueue.global(qos: .utility).async { [unowned self] in
            while true {
                Thread.sleep(forTimeInterval: Double(config.seconds))
                if turnOn { self.turnOn(); turnOn = false }
                else { self.turnOff(); turnOn = true }
            }
        }
    }
}
