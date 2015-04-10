//
//  LogMessageFormatter.swift
//  LogKit
//
//  Created by Robbert Brandsma on 09-04-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

/**
The LogMessageFormatter abstract class is used to transform log messages. It is given an `NSAttributedString` trough the `formatMessage` method, and should return the transformed text as another or alternatively (when no transformation needs to happen) the same NSAttributedString.

You could, for example, create a Markdown or HTML parser as a subclass of this class. Then, in the `formatMessage` method, you would read the input string, parse the tags into attributes for the NSAttributedString, and finally strip all the tags before returning the string. A less useful, but still possible use case is replacing certain characters or character sequences by, for example, emoji or other character sequences.
*/
public class LogMessageFormatter {
    public init() {}
    
    /**
    The formatMessage method
    */
    public func formatMessage(message: NSAttributedString) -> NSAttributedString {
        assertionFailure("LogMessageFormatter is an abstract class. Subclass it and override the formatMessage method.")
        abort()
    }
}