//
//  ProxyLogger.swift
//  LogKit
//
//  Created by Robbert Brandsma on 16-04-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

private func inCaseOfNil<T>(defaultValue: T, @autoclosure _ getClosure: () -> T?) -> T {
    if let val = getClosure() {
        return val
    } else {
        return defaultValue
    }
}

public class ProxyLogger : Logger {
    
    internal var parent: Logger?
    public let frameworkName: String
    
    internal init(frameworkName: String, parent: Logger?) {
        self.parent = parent
        self.frameworkName = frameworkName
    }
    
    public override dynamic var debugQuickLookObject: AnyObject? {
        return "Proxy logger for \(frameworkName)"
    }
    
    // MARK: - Logging
    public override func log(message: LogMessage) {
        parent?.log(message)
    }
    
    public override func log(level: LogKitLevel, message: String, _ function: String, _ file: String, _ line: Int, _ column: Int) {
        parent?.log(level, message: message, function, file, line, column)
    }
    
    public override func log(level: LogKitLevel, message: NSAttributedString, _ function: String, _ file: String, _ line: Int, _ column: Int) {
        parent?.log(level, message: message, function, file, line, column)
    }
    
    // MARK: - Property Redirection
    public override var logElements: [LogKitElement] {
        get { return inCaseOfNil([LogKitElement](), parent?.logElements) }
        set { fatalError("\(__FUNCTION__) not available on proxy loggers (readonly).") }
    }
    
    public override var logElementSeparator: String {
        get { return inCaseOfNil("", parent?.logElementSeparator) }
        set { fatalError("\(__FUNCTION__) not available on proxy loggers (readonly).") }
    }
    
    public override var playgroundMode: Bool {
        get { return inCaseOfNil(false, parent?.playgroundMode) }
        set { fatalError("\(__FUNCTION__) not available on proxy loggers (readonly).") }
    }
    
    public override var logColors: [LogKitLevel: UIColor] {
        get { return inCaseOfNil([LogKitLevel: UIColor](), parent?.logColors) }
        set { fatalError("\(__FUNCTION__) not available on proxy loggers (readonly).") }
    }
    
    public override var destinations: [LogDestination] {
        get { fatalError("Destinations are not accessible on proxy loggers.") }
        set { fatalError("Destinations are not accessible on proxy loggers.") }
    }
    
    public override var useForFrameworks: Bool {
        get { return true }
        set { fatalError("Cannot set a proxy logger to be used for frameworks.") }
    }
}