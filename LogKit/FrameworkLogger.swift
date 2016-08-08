//
//  FrameworkLogger.swift
//  LogKit
//
//  Created by Robbert Brandsma on 16-04-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public class FrameworkLogger : _LoggerType {
    
    public let frameworkIdentifier: String
    
    internal init(frameworkIdentifier: String) {
        self.frameworkIdentifier = frameworkIdentifier
    }
    
    // MARK: - Logging
    public func log(_ level: LogKitLevel, message: String, _ function: String, _ file: String, _ line: Int, _ column: Int) {
        Logger.frameworkLogger?.log(level, message: AttributedString(string: message), frameworkIdentifier: frameworkIdentifier, function, file, line, column)
    }
    
    public func log(_ level: LogKitLevel, message: AttributedString, _ function: String, _ file: String, _ line: Int, _ column: Int) {
        Logger.frameworkLogger?.log(level, message: message, frameworkIdentifier: frameworkIdentifier, function, file, line, column)
    }
}
