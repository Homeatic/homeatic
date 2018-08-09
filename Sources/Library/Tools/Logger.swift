//
//  Logger.swift
//  Homeatic
//
//  Created by Vincent Saluzzo on 06/08/2018.
//

import Foundation

final public class Log {
    
    static let `default` = Log()
    
    let name: String
    init(name: String = "") {
        self.name = name
    }
    
    private func format(_ msg: String, _ caller: String, _ lineNumber: Int, _ file: String) -> String {
        var component = file.split(separator: "/").last!.split(separator: ".")
        component.removeLast()
        var log = "\(component.joined(separator: ".")): \(msg)"//" in \(caller): \(msg)"
        if name.isEmpty == false {
            log = "\(self.name): \(log)"
        }
        return log
    }
    
    public func verbose(_ msg: String, caller: String = #function, lineNumber: Int = #line, file: String = #file) {
        print("[VERBOSE] \(format(msg, caller, lineNumber, file))")
    }
    
    public func info(_ msg: String, caller: String = #function, lineNumber: Int = #line, file: String = #file) {
        print("[INFO] \(format(msg, caller, lineNumber, file))")
    }
    
    public func warning(_ msg: String, caller: String = #function, lineNumber: Int = #line, file: String = #file) {
        print("[WARNING] \(format(msg, caller, lineNumber, file))")
    }
    
    public func error(_ msg: String, caller: String = #function, lineNumber: Int = #line, file: String = #file) {
        print("[ERROR] \(format(msg, caller, lineNumber, file))")
    }
    
    public func debug(_ msg: String, caller: String = #function, lineNumber: Int = #line, file: String = #file) {
        print("[DEBUG] \(format(msg, caller, lineNumber, file))")
    }
    
    public func fatalError(_ msg: String, caller: String = #function, lineNumber: Int = #line, file: String = #file) -> Never {
        Swift.fatalError("\(format(msg, caller, lineNumber, file))")
    }
}


extension Log {
    static public func verbose(_ msg: String, caller: String = #function, lineNumber: Int = #line, file: String = #file) {
        Log.default.verbose(msg, caller: caller, lineNumber: lineNumber, file: file)
    }
    
    static public func info(_ msg: String, caller: String = #function, lineNumber: Int = #line, file: String = #file) {
        Log.default.info(msg, caller: caller, lineNumber: lineNumber, file: file)
    }
    
    static public func warning(_ msg: String, caller: String = #function, lineNumber: Int = #line, file: String = #file) {
        Log.default.warning(msg, caller: caller, lineNumber: lineNumber, file: file)
    }
    
    static public func error(_ msg: String, caller: String = #function, lineNumber: Int = #line, file: String = #file) {
        Log.default.error(msg, caller: caller, lineNumber: lineNumber, file: file)
    }
    
    static public func debug(_ msg: String, caller: String = #function, lineNumber: Int = #line, file: String = #file) {
        Log.default.debug(msg, caller: caller, lineNumber: lineNumber, file: file)
    }
    
    static public func fatalError(_ msg: String, caller: String = #function, lineNumber: Int = #line, file: String = #file) -> Never {
        Log.default.fatalError(msg, caller: caller, lineNumber: lineNumber, file: file)
    }
}
