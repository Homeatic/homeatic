//
//  BinarySensor.swift
//  Homeatic
//
//  Created by Vincent Saluzzo on 05/08/2018.
//

import Foundation
import RxSwift

public protocol BinarySensor: Component {
    var isOn: BehaviorSubject<Bool> { get }
}
