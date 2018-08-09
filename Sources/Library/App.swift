//
//  App.swift
//  Homeatic
//
//  Created by Vincent Saluzzo on 05/08/2018.
//

import Foundation
import Files
import RxSwift

final public class App {
    
    public static var `default`: App!
    
    public let componentManager: ComponentManager
    public var loadedPlatforms = [Platforms]()
    let configurationFolder: Folder
    var configuration: Configuration
    
    var appDisposable: Disposable?
    
    public init(configurationFolder: Folder) {
        self.configurationFolder = configurationFolder
        componentManager = ComponentManager(withConfigurationFolder: configurationFolder)
        
        guard let configurationFile = try? self.configurationFolder.createFileIfNeeded(withName: Configuration.fileName) else {
            Log.fatalError("Can't read configuration file")
        }
        do {
            if try configurationFile.read().isEmpty {
                try configurationFile.write(data: "{}".data(using: .utf8)!)
            }
        } catch {
            Log.fatalError("Can't initialize empty configuration file")
        }
        
        configuration = Configuration(withConfigurationFile: configurationFile)
        
        App.`default` = self
    }
    
    deinit {
        appDisposable?.dispose()
    }
    func loadPlatforms() -> Observable<[Platforms]> {
        var platformToInitialize = [Observable<Platforms>]()
        
        for (platformEntryName, dictionary) in configuration.platforms {
            if let p = Platform.supportedPlatforms.find({ $0.configurationEntryName == platformEntryName }) {
                platformToInitialize.append(p.initializingWith(configuration: dictionary, componentManager: componentManager))
            }
        }
      
        return Observable.zip(platformToInitialize)
    }
    
    func reload() -> Observable<Void> {
        return loadPlatforms()
            .map { [unowned self] (platforms) in
                self.loadedPlatforms = platforms
                return
            }
    }
    
    public func run() {
        // load configuration
        appDisposable = reload().subscribe()
    }
    
    public var webServerConfiguration: Configuration.Webserver? {
        return configuration.webserver
    }
}
