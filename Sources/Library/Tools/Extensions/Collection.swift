//
//  Collection.swift
//  Homeatic
//
//  Created by Vincent Saluzzo on 06/08/2018.
//

import Foundation


extension Collection {
    func find(_ elementCorresponding: (Element) -> Bool) -> Element? {
        for element in self {
            if elementCorresponding(element) {
                return element
            }
        }
        
        return nil
    }
    
    func substractedBy<C: Collection>(_ otherCollection: C, using: (_ lhs: Element, _ rhs: Element) -> Bool) -> [Element] where C.Element == Element {
        var new = [Element]()
        
        for element in self {
            let correspondingElement = otherCollection.filter { using( element, $0) }.first
            if correspondingElement == nil {
                new.append(element)
            }
        }
        
        return new
    }
}
