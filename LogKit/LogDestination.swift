//
//  LogDestination.swift
//  LogKit
//
//  Created by Robbert Brandsma on 17-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

/**
The LogDestination abstract class is the final component in the logging chain. It takes a message and outputs or stores it somewhere. It currently has one concrete subclass implemented in the core of LogKit: LogDestinationConsole.

A LogDestination object may optionally be configured with one or more formatters of the class LogMessageFormatter, and at most one encoder of the class LogMessageEncoder.
*/
public class LogDestination {
    public init() {}
    
    /// Optionally, the encoder that will be used to encode the log message before logging it.
    public var encoder: LogMessageEncoder?
    
    /// Zero or more formatters that will be used to format messages before encoding them.
    public var formatters: [LogMessageFormatter] = []
    
    /**
    
    */
    public func prepareAndLogMessage(message: LogMessage) {
        let attributedText = self.formatMessage(message)
        log(attributedText)
    }
    
    public func formatMessage(message: LogMessage) -> NSAttributedString {
        // Get the message text
        var messageText = message.loggableAttributedText
        
        // Run it trough the formatters
        for formatter in formatters {
            messageText = formatter.formatMessage(messageText)
        }
        
        return messageText
    }
    
    public func encode(message: NSAttributedString) -> String {
        if let encoder = encoder {
            return encoder.encodeLogMessage(message)
        } else {
            return message.string
        }
    }
    
    public func log(message: String) {
        assertionFailure("You should not use the LogDestination class directly and you should override one of the log function in every subclass.")
    }
    
    public func log(message: NSAttributedString) {
        self.log(self.encode(message))
    }
    public func didAttachToLogger(logger: Logger) {}
}