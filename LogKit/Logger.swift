//
//  LogKit.swift
//  LogKit
//
//  Created by Robbert Brandsma on 27-02-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import UIKit

public class Logger {

    // MARK: Initializer
    public init() { }

    // MARK: - Settings
    public var logElements: [LogKitElement] = [.Static("["), .LogLevel, .Static("]"), .FileName, .FunctionName, .LogMessage]
    public var logElementSeparator = " "
    public var playgroundMode = false

    public var logColors: [LogKitLevel: UIColor] = [
        .Verbose: UIColor.lightGrayColor(),
        .Debug: UIColor.purpleColor(),
        .Info: UIColor.greenColor(),
        .Warning: UIColor.orangeColor(),
        .Error: UIColor.redColor()
    ]
    
    lazy public var destinations: [LogDestination] = {
        return [LogDestinationConsole()]
        }()
    
    // MARK: - State
    private var lastLogMessageForPlaygroundMode: LogMessage?

    // MARK: - Logging
    public func log(level: LogKitLevel, message: String, _ function: String = __FUNCTION__, _ file: String = __FILE__, _ line: Int = __LINE__, _ column: Int =  __COLUMN__) {
        
        let attributedMessage: NSAttributedString
        
        if let fgColor = logColors[level] {
            attributedMessage = NSAttributedString(string: message, attributes: [NSForegroundColorAttributeName: fgColor])
        } else {
            attributedMessage = NSAttributedString(string: message)
        }
        
        self.log(level, message: attributedMessage, function, file, line, column)
    }
    
    public func log(level: LogKitLevel, message: NSAttributedString, _ function: String = __FUNCTION__, _ file: String = __FILE__, _ line: Int = __LINE__, _ column: Int =  __COLUMN__) {
        let logMessage = LogMessage(text: message, logLevel: level, function: function, fullFilePath: file, line: line, column: column, elements: self.logElements)
        
        log(logMessage)
    }
    
    public func log(message: LogMessage) {
        if (playgroundMode) {
            lastLogMessageForPlaygroundMode = message
        }
        
        for destination in self.destinations {
            destination.prepareAndLogMessage(message)
        }
    }
    
    public dynamic var debugQuickLookObject: AnyObject? {
        if (playgroundMode) {
            let text = lastLogMessageForPlaygroundMode?.loggableAttributedText
            lastLogMessageForPlaygroundMode = nil
            return text
        } else {
            return "Logger with \(destinations.count) destination(s)"
        }
    }
    
    // MARK: - For Frameworks
    var useForFrameworks = false
    func loggerForFrameworkWithName(frameworkName: String) -> Logger {
        return ProxyLogger(frameworkName: frameworkName, parent: self)
    }
}
