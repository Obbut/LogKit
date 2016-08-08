//
//  LogKitConvenience.swift
//  LogKit
//
//  Created by Robbert Brandsma on 19-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public extension _LoggerType {
    // MARK: - Convenience Logging with unattributed strings
    public func verbose(_ message: String, function: String = #function, file: String = #file, line: Int = #line, column: Int =  #column) {
        self.log(.verbose, message: message, function, file, line, column)
    }
    
    public func debug(_ message: String, function: String = #function, file: String = #file, line: Int = #line, column: Int =  #column) {
        self.log(.debug, message: message, function, file, line, column)
    }
    
    public func info(_ message: String, function: String = #function, file: String = #file, line: Int = #line, column: Int =  #column) {
        self.log(.info, message: message, function, file, line, column)
    }
    
    public func warning(_ message: String, function: String = #function, file: String = #file, line: Int = #line, column: Int =  #column) {
        self.log(.warning, message: message, function, file, line, column)
    }
    
    public func error(_ message: String, function: String = #function, file: String = #file, line: Int = #line, column: Int =  #column) {
        self.log(.error, message: message, function, file, line, column)
    }
    
    // MARK - Convenience Logging with attributed strings
    public func verbose(_ message: AttributedString, function: String = #function, file: String = #file, line: Int = #line, column: Int =  #column) {
        self.log(.verbose, message: message, function, file, line, column)
    }
    
    public func debug(_ message: AttributedString, function: String = #function, file: String = #file, line: Int = #line, column: Int =  #column) {
        self.log(.debug, message: message, function, file, line, column)
    }
    
    public func info(_ message: AttributedString, function: String = #function, file: String = #file, line: Int = #line, column: Int =  #column) {
        self.log(.info, message: message, function, file, line, column)
    }
    
    public func warning(_ message: AttributedString, function: String = #function, file: String = #file, line: Int = #line, column: Int =  #column) {
        self.log(.warning, message: message, function, file, line, column)
    }
    
    public func error(_ message: AttributedString, function: String = #function, file: String = #file, line: Int = #line, column: Int =  #column) {
        self.log(.error, message: message, function, file, line, column)
    }
}

/// Constructs a LogDestinationConsole instance, and configures it with an ConfigurableRenderer and XcodeColorsTransformer.
public func XcodeColorsConsoleDestination() -> LogDestinationConsole {
    let ld = LogDestinationConsole()
    let render = ConfigurableLogRenderer()
    render.transformers = [XcodeColorsTransformer()]
    ld.renderer = render
    return ld
}
