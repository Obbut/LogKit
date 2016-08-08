//
//  LogKit.swift
//  LogKit
//
//  Created by Robbert Brandsma on 27-02-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public protocol _LoggerType {
    func log(_ level: LogKitLevel, message: String, _ function: String, _ file: String, _ line: Int, _ column: Int)
    func log(_ level: LogKitLevel, message: AttributedString, _ function: String, _ file: String, _ line: Int, _ column: Int)
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
    internal func log(_ level: LogKitLevel, message: AttributedString, frameworkIdentifier: String?, _ function: String, _ file: String, _ line: Int, _ column: Int) {
        if let id = frameworkIdentifier where minimumLogLevelForFrameworkWithIdentifier(id) > level { return }
        
        let logMessage = LogMessage(text: message, logLevel: level, function: function, fullFilePath: file, line: line, column: column, frameworkIdentifier: frameworkIdentifier)
        log(logMessage)
    }
    
    public func log(_ level: LogKitLevel, message: String, _ function: String = #function, _ file: String = #file, _ line: Int = #line, _ column: Int =  #column) {
        let attributedMessage = AttributedString(string: message)
        
        self.log(level, message: attributedMessage, function, file, line, column)
    }
    
    public func log(_ level: LogKitLevel, message: AttributedString, _ function: String = #function, _ file: String = #file, _ line: Int = #line, _ column: Int =  #column) {
        // Forward to the internal logging function
        log(level, message: message, frameworkIdentifier: nil, function, file, line, column)
    }
    
    internal func log(_ message: LogMessage) {
        for destination in self.destinations {
            destination.log(message)
        }
    }
    
    // MARK: - For Frameworks
    internal static weak var frameworkLogger: Logger? = nil
    
    public var useForFrameworks: Bool {
        get { return self === Logger.frameworkLogger }
        set { Logger.frameworkLogger = self }
    }
    
    public class func loggerForFrameworkWithIdentifier(_ frameworkIdentifier: String) -> FrameworkLogger {
        return FrameworkLogger(frameworkIdentifier: frameworkIdentifier)
    }
    
    // MARK: - Framework Settings
    private var frameworkLogLevels = [String: LogKitLevel]()
    public func setMinimumLogLevel(_ level: LogKitLevel, forFrameworkWithIdentifier identifier: String) {
        frameworkLogLevels[identifier] = level
    }
    
    /// The default minimum log level for every framework is warning.
    public func minimumLogLevelForFrameworkWithIdentifier(_ identifier: String) -> LogKitLevel {
        return frameworkLogLevels[identifier] ?? .warning
    }
}
