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

A LogDestination object may optionally be configured with one or more formatters of the class LogMessageFormatter, and at most one encoder of the class LogMessageEncoder. You do not _have_ to support formatters and encoders, but you are recommended to do so unless you have a clear reason not to. Supporing formatters and encoders is very easy, as LogDestination provides default implementations for the `formatMessage()` and `encode()` methods.
*/
public class LogDestination {
    public init() {}
    
    /// Optionally, the encoder that will be used to encode the log message before logging it.
    public var encoder: LogMessageEncoder?
    
    /// Zero or more formatters that will be used to format messages before encoding them.
    public var formatters: [LogMessageFormatter] = []
    
    /**
    `Logger` will call `prepareAndLogMessage()` when it logs a message to a destination. The default implementation formats the message using `formatMessage()`, then logs the attributed string using `log()`.
    
    #### Possibly rename this method to just 'log' and provide this as the default implementation?
    
    - parameter message: The message – an instance of the LogMessage struct – that this destination should log.
    */
    public func prepareAndLogMessage(message: LogMessage) {
        let attributedText = self.formatMessage(message)
        log(attributedText)
    }
    
    /**
    Formats the message using the configured formatters.
    
    - parameter message: The message to format
    - returns: The formatted message, as NSAttributedString
    */
    public func formatMessage(message: LogMessage) -> NSAttributedString {
        // Get the message text
        var messageText = message.loggableAttributedText
        
        // Run it trough the formatters
        for formatter in formatters {
            messageText = formatter.formatMessage(messageText)
        }
        
        return messageText
    }
    
    /**
    Encodes the message using the configured encoder.
    
    - parameter message: A formatted message, as NSAttributedString
    - returns: The message, formatted as String
    */
    public func encode(message: NSAttributedString) -> String {
        if let encoder = encoder {
            return encoder.encodeLogMessage(message)
        } else {
            return message.string
        }
    }
    
    /**
    Logs a formatted, encoded log message. If you want to support logging plain strings, you need to override this method. The default implementation of this method calls `assertionFailure()` and will crash your program.
    */
    public func log(message: String) {
        assertionFailure("You should not use the LogDestination class directly and you should override one of the log functions in every subclass.")
    }
    
    /**
    Logs a formatted message. The default implementation of this method encodes the message by using `encode`, and logs by supplying `log()` with the resulting String.
    
    - parameter message: A formatted message, as NSAttributedString
    */
    public func log(message: NSAttributedString) {
        self.log(self.encode(message))
    }
    
    /// Notification method without default implementation. This is called whenever a user attaches the logging destination to a Logger.
    public func didAttachToLogger(logger: Logger) {}
}