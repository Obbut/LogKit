//
//  ProxyLogger.swift
//  LogKit
//
//  Created by Robbert Brandsma on 16-04-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

internal class ProxyLogger : Logger {
    
    let parent: Logger
    let frameworkName: String
    init(frameworkName: String, parent: Logger) {
        self.parent = parent
        self.frameworkName = frameworkName
    }
    
    override func log(message: LogMessage) {
        parent.log(message)
    }
    
    override func log(level: LogKitLevel, message: String, _ function: String, _ file: String, _ line: Int, _ column: Int) {
        parent.log(level, message: message, function, file, line, column)
    }
    
    override func log(level: LogKitLevel, message: NSAttributedString, _ function: String, _ file: String, _ line: Int, _ column: Int) {
        parent.log(level, message: message, function, file, line, column)
    }
    
}