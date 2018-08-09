//
//  Switch.swift
//  Homeatic
//
//  Created by Vincent Saluzzo on 05/08/2018.
//

import Foundation
import RxSwift

public protocol Switch: Component {
    var state: BehaviorSubject<Bool> { get }
}
