//
//  Light.swift
//  Homeatic
//
//  Created by Vincent Saluzzo on 05/08/2018.
//

import Foundation
import RxSwift


public protocol Light: Component {
    var isOnObservable: Observable<Bool> { get }
    var isOn: Bool { get }
    
    @discardableResult
    func turnOn() -> Observable<Void>
    
    @discardableResult
    func turnOff() -> Observable<Void>
}
