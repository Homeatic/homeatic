//
//  Bool.swift
//  Homeatic
//
//  Created by Vincent Saluzzo on 07/08/2018.
//

import Foundation

extension Bool {
    var emoji: String {
        if self { return "👍" }
        else { return "👎" }
    }
}
