//
//  CronComponents.swift
//  Homeatic
//
//  Created by Vincent Saluzzo on 05/08/2018.
//

import Foundation
import RxSwift



final class CronComponents {
    let binarySensors: [CronComponentsBinarySensor]
    let lights: [CronComponentsLight]
    let switchs: [CronComponentsSwitch]
    private init(withComponents comps: ([CronComponentsBinarySensor], [CronComponentsLight], [CronComponentsSwitch])) {
        self.binarySensors = comps.0
        self.lights = comps.1
        self.switchs = comps.2
    }
}

extension CronComponents: Platforms {
    static let configurationEntryName = "cronComponent"
    static func initializingWith(configuration c: [String: Any], componentManager: ComponentManager) -> Observable<Platforms> {
        do {
            let configuration: Configuration = try c.to()
            guard let existingRegistry = componentManager.getComponentRegistry(forPlatform: CronComponents.self) as? [String : String] else {
                return .error(PlatformsError.registryError)
            }
            
            
            
            let binarySensors = try (configuration.binarySensor ?? []).map { configuration in
                
                try componentManager.registerComponent(CronComponentsBinarySensor(withConfiguration: configuration,
                                                                                  withComponentId: existingRegistry
                                                                                    .reversed()
                                                                                    .first(where: { $0.value == configuration.identifier })?
                                                                                    .key))
            }
            let lights = try (configuration.light ?? []).map {configuration in
                
                try componentManager.registerComponent(CronComponentsLight(withConfiguration: configuration,
                                                                           withComponentId: existingRegistry
                                                                            .reversed()
                                                                            .first(where: { $0.value == configuration.identifier })?
                                                                            .key))
            }
            let switchs = try (configuration.switch ?? []).map {configuration in
                
                try componentManager.registerComponent(CronComponentsSwitch(withConfiguration: configuration,
                                                                            withComponentId: existingRegistry
                                                                                .reversed()
                                                                                .first(where: { $0.value == configuration.identifier })?
                                                                                .key))
            }
            
            return Observable
                .zip(Observable.zip(binarySensors),
                     Observable.zip(lights),
                     Observable.zip(switchs))
                
                .map { CronComponents(withComponents: ($0)) }
            
        } catch {
            if error is DecodingError {
                return .error(PlatformsError.badConfiguration(error))
            } else {
                return .error(error)
            }
        }
    }
}

extension CronComponents {
    struct Configuration: Codable {
        var binarySensor: [ComponentConfiguration]?
        var `switch`: [ComponentConfiguration]?
        var light: [ComponentConfiguration]?
    }
}

extension CronComponents.Configuration {
    struct ComponentConfiguration: Codable {
        var seconds: Int
        var identifier: String
    }
}


extension CronComponents.Configuration.ComponentConfiguration {
    enum Error: Swift.Error {
        case malformedCronExpression
    }
}
