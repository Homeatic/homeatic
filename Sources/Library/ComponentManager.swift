//
//  ComponentManager.swift
//  Homeatic
//
//  Created by Vincent Saluzzo on 05/08/2018.
//

import Foundation
import RxSwift
import Files

final public class ComponentManager {
    
    let eventBusLogger: (Event) -> () = { e in Log.info("\(e.component)(\(e.component.componentId ?? "")) => \(e.changeOf.description)")}
    
    
    public var components = [Component]() {
        didSet {
            for c in components where c.componentId == nil {
                c.componentId = UUID().uuidString
            }
            
            if oldValue.count < components.count {
                for added in components.substractedBy(oldValue, using: { $0.componentId == $1.componentId }) {
                    onAddingNewComponent(added)
                }
            } else {
                for removed in oldValue.substractedBy(components, using: { $0.componentId == $1.componentId }) {
                    onRemovingComponent(removed)
                }
            }
            
            saveComponentsRegistry()
        }
    }
    public var eventBus: Observable<Event> { return _eventBus.share() }
    
    
    fileprivate var _eventBus: PublishSubject<Event>
    fileprivate var componentDisposeBag = DisposeBag()
    let eventLoggerDispose = DisposeBag()
    let configurationFolder: Folder
    init(withConfigurationFolder folder: Folder) {
        self.configurationFolder = folder
        _eventBus = PublishSubject()
        
        eventBus.subscribe(onNext: eventBusLogger).disposed(by: eventLoggerDispose)
        
    }
    
    private func onAddingNewComponent(_ c: Component) {
        Log.info("Adding new component (\(c)) identified by \(String(describing: c.componentId))")
    }
    
    private func onRemovingComponent(_ c: Component) {
        Log.info("Removing component (\(c)) identified by \(String(describing: c.componentId))")
    }
    
    private func saveComponentsRegistry() {
        var dict = [String: Any]()
        for c in components where c.componentId != nil {
            dict[c.componentId!] = [
                "localIdentifier": c.localIdentifier,
                "platforms": c.platform.configurationEntryName
            ]
        }
        do {
            let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let file = try configurationFolder.createFileIfNeeded(withName: "registry.json")
            try file.write(data: json)
        } catch {
            if case File.Error.writeFailed = error {
                Log.error("Can't save or create component registry")
            } else {
                Log.error("Can't serialize component registry: \(error)")
            }
        }
    }
    
    func getComponentsRegistry() throws -> [String: [String: Any]] {
        let file = try configurationFolder.createFileIfNeeded(withName: "registry.json")
        let registryJson = try file.read()
        return try JSONSerialization.jsonObject(with: registryJson.isEmpty ? "{}".data(using: .utf8)! : registryJson , options: []) as! [String: [String: Any]]
    }
    
    func getComponentRegistry(forPlatform platform: Platforms.Type) -> [String: Any] {
        guard let registry = try? getComponentsRegistry() else { return [:] }
        return registry
            .filter { (arg) -> Bool in
                let (_, value) = arg
                
                return value["platforms"] as? String == platform.configurationEntryName
            }
            .mapValues { (arg) -> Any in
                return arg["localIdentifier"]!
        }
        
    }
}


extension ComponentManager {
    public struct Event {
        let component: Component
        let changeOf: ChangeOf
    }
}

extension ComponentManager.Event {
    public enum ChangeOf {
        case boolean(from: Bool?, to: Bool)
    }
}

extension ComponentManager.Event.ChangeOf {
    var description: String {
        switch self {
        case .boolean(let oldValue, let newValue):
            if let oldValue = oldValue {
                return "\(oldValue.emoji) ➤ \(newValue.emoji)"
            } else {
                return "✘ ➤ \(newValue.emoji)"
            }
        }
    }
}


extension ComponentManager {
    func registerComponent<C: Switch>(_ aSwitch: C) -> Observable<C> {
        components.append(aSwitch)
        aSwitch.state
            .scan((nil, false), accumulator: { (oldValue, newValue) -> (Bool?, Bool) in
                return (oldValue.1, newValue)
            })
            .subscribe { [weak self] (event) in
                switch event {
                case .next(let oldValue, let newValue):
                    self?._eventBus.onNext(Event(component: aSwitch,
                                                 changeOf: .boolean(from: oldValue, to: newValue)))
                default: break
                }
            }
            .disposed(by: componentDisposeBag)
        return .just(aSwitch)
    }
    
    func registerComponent<C: BinarySensor>(_ binarySensor: C) -> Observable<C> {
        components.append(binarySensor)
        binarySensor.isOn
            .scan((nil, false), accumulator: { (oldValue, newValue) -> (Bool?, Bool) in
                return (oldValue.1, newValue)
            })
            .subscribe { [weak self] (event) in
                switch event {
                case .next(let oldValue, let newValue):
                    self?._eventBus.onNext(Event(component: binarySensor,
                                                 changeOf: .boolean(from: oldValue, to: newValue)))
                default: break
                }
            }
            .disposed(by: componentDisposeBag)
        
        return .just(binarySensor)
    }
    
    func registerComponent<C: Light>(_ light: C) -> Observable<C> {
        components.append(light)
        light.isOnObservable
            .scan((nil, false), accumulator: { (oldValue, newValue) -> (Bool?, Bool) in
                return (oldValue.1, newValue)
            })
            .subscribe { [weak self] (event) in
                switch event {
                case .next(let oldValue, let newValue):
                    self?._eventBus.onNext(Event(component: light,
                                                 changeOf: .boolean(from: oldValue, to: newValue)))
                default: break
                }
            }
            .disposed(by: componentDisposeBag)
        
        return .just(light)
    }
}
