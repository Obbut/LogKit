//
//  LogKit.swift
//  LogKit
//
//  Created by Robbert Brandsma on 27-02-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import UIKit

public protocol _LoggerType {
    func log(level: LogKitLevel, message: String, _ function: String, _ file: String, _ line: Int, _ column: Int)
    func log(level: LogKitLevel, message: NSAttributedString, _ function: String, _ file: String, _ line: Int, _ column: Int)
}

public class Logger: _LoggerType {

    // MARK: Initializer
    public init() {
        if Logger.frameworkLogger == nil {
            self.useForFrameworks = true
        }
    }

    // MARK: - Settings
    lazy public var destinations: [LogDestination] = {
        return [LogDestinationConsole()]
        }()
    
    // MARK: - Logging
    internal func log(level: LogKitLevel, message: NSAttributedString, frameworkIdentifier: String?, _ function: String, _ file: String, _ line: Int, _ column: Int) {
        let logMessage = LogMessage(text: message, logLevel: level, function: function, fullFilePath: file, line: line, column: column)
        log(logMessage)
    }
    
    public func log(level: LogKitLevel, message: String, _ function: String = __FUNCTION__, _ file: String = __FILE__, _ line: Int = __LINE__, _ column: Int =  __COLUMN__) {
        let attributedMessage = NSAttributedString(string: message)
        
        self.log(level, message: attributedMessage, function, file, line, column)
    }
    
    public func log(level: LogKitLevel, message: NSAttributedString, _ function: String = __FUNCTION__, _ file: String = __FILE__, _ line: Int = __LINE__, _ column: Int =  __COLUMN__) {
        // Forward to the internal logging function
        log(level, message: message, frameworkIdentifier: nil, function, file, line, column)
    }
    
    internal func log(message: LogMessage) {
        for destination in self.destinations {
            destination.log(message)
        }
    }
    
    // MARK: - For Frameworks
    private static var frameworkProxies = [FrameworkLogger]()
    private static weak var frameworkLogger: Logger? = nil {
        didSet {
            for proxy in frameworkProxies {
                proxy.parent = frameworkLogger
            }
        }
    }
    
    public var useForFrameworks: Bool {
        get { return self === Logger.frameworkLogger }
        set { Logger.frameworkLogger = self }
    }
    
    public class func loggerForFrameworkWithIdentifier(frameworkIdentifier: String) -> FrameworkLogger {
        let proxies = frameworkProxies.filter { $0.frameworkIdentifier == frameworkIdentifier }
        assert(proxies.count <= 1, "OMG TOO MANY FRAMEWORK LOGGERS OMGOMGOMG WHAT THE **** IS GOING ON")
        
        if proxies.count == 1 {
            return proxies[0]
        } else {
            let proxy = FrameworkLogger(frameworkIdentifier: frameworkIdentifier, parent: frameworkLogger)
            frameworkProxies.append(proxy)
            return proxy
        }
    }
}
