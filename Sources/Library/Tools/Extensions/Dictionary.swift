//
//  Dictionary.swift
//  Homeatic
//
//  Created by Vincent Saluzzo on 06/08/2018.
//

import Foundation

extension Dictionary {
    func to<C: Codable>(_ cType: C.Type) throws-> C where Key == String, Value == Any {
        return try to() as C
    }
    
    func to<C: Codable>() throws -> C where Key == String, Value == Any {
        let decoder = JSONDecoder()
        return try decoder.decode(C.self, from: JSONSerialization.data(withJSONObject: self, options: []))
    }
    
}
