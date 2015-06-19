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
        if let id = frameworkIdentifier where minimumLogLevelForFrameworkWithIdentifier(id) > level { return }
        
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
    internal static weak var frameworkLogger: Logger? = nil
    
    public var useForFrameworks: Bool {
        get { return self === Logger.frameworkLogger }
        set { Logger.frameworkLogger = self }
    }
    
    public class func loggerForFrameworkWithIdentifier(frameworkIdentifier: String) -> FrameworkLogger {
        return FrameworkLogger(frameworkIdentifier: frameworkIdentifier)
    }
    
    // MARK: - Framework Settings
    private var frameworkLogLevels = [String: LogKitLevel]()
    public func setMinimumLogLevel(level: LogKitLevel, forFrameworkWithIdentifier identifier: String) {
        frameworkLogLevels[identifier] = level
    }
    
    /// The default minimum log level for every framework is warning.
    public func minimumLogLevelForFrameworkWithIdentifier(identifier: String) -> LogKitLevel {
        return frameworkLogLevels[identifier] ?? .Warning
    }
}
