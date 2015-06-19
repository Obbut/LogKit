//
//  FrameworkLogger.swift
//  LogKit
//
//  Created by Robbert Brandsma on 16-04-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public class FrameworkLogger : _LoggerType {
    
    internal var parent: Logger?
    public let frameworkIdentifier: String
    
    internal init(frameworkIdentifier: String, parent: Logger?) {
        self.parent = parent
        self.frameworkIdentifier = frameworkIdentifier
    }
    
    // MARK: - Logging
    public func log(level: LogKitLevel, message: String, _ function: String, _ file: String, _ line: Int, _ column: Int) {
        parent?.log(level, message: NSAttributedString(string: message), frameworkIdentifier: frameworkIdentifier, function, file, line, column)
    }
    
    public func log(level: LogKitLevel, message: NSAttributedString, _ function: String, _ file: String, _ line: Int, _ column: Int) {
        parent?.log(level, message: message, frameworkIdentifier: frameworkIdentifier, function, file, line, column)
    }
}