//
//  Configuration.swift
//  Homeatic
//
//  Created by Vincent Saluzzo on 05/08/2018.
//

import Foundation
import Files
import RxSwift
public class Configuration {
    typealias PlatformConfiguration = [String: Any]
    
    static let fileName = "configuration.json"
    
    let platforms: [String: PlatformConfiguration]
    let webserver: Webserver?
    
    init(withConfigurationFile configurationFile: Files.File) { //}, platformManager: PlatformManager, componentManager: ComponentManager) {
        guard let configurationFileData = try? configurationFile.read() else {
            Log.fatalError("Can't read configuration file")
        }
        
        guard let jsonData = try? JSONSerialization.jsonObject(with: configurationFileData, options: JSONSerialization.ReadingOptions.init(rawValue: 0)),
            let json: [String: Any] = jsonData as? [String : Any] else {
            Log.fatalError("Can't decode configuration file as JSON. Malformatted JSON file ?")
        }
        
        platforms = (json["platforms"] as? [String : [String : Any]]) ?? [:]
        
        do {
            if let webServerAny = json["webserver"] {
                let webServerJsonData = try JSONSerialization.data(withJSONObject: webServerAny,
                                                                   options: .prettyPrinted)
                webserver = try JSONDecoder().decode(Webserver.self, from: webServerJsonData)
            } else {
                webserver = nil
            }
        } catch {
            Log.fatalError("Webserver configuration malformed: \(error)")
        }
    }
}

extension Configuration {
    public struct Webserver: Codable {
        public let credentials: Credentials
        public let bearerSecret: String
    }
}

extension Configuration.Webserver {
    public struct Credentials: Codable {
        public var username: String
        public var password: String
    }
}
