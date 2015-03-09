//
//  RBLogger.swift
//  RBLogger
//
//  Created by Robbert Brandsma on 27-02-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import UIKit

public let logger = RBLogger()

// MARK: Logger Element
// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

public protocol RBLoggerElement {
    var stringValue: String { get }
    var staticValue: RBStaticLoggerElement { get }
}

public enum RBStaticLoggerElement: RBLoggerElement {
    case FullFilePath, FileName, FunctionName, LineNumber, ColumnNumber, LogMessage, LogLevel, Custom
    
    public var stringValue: String { return self.description }
    public var staticValue: RBStaticLoggerElement { return self }
    
    public var description: String {
        switch self {
        case .FileName:
            return "File Name"
        case .FullFilePath:
            return "Full File Path"
        case .FunctionName:
            return "Function Name"
        case .LineNumber:
            return "Line Number"
        case .ColumnNumber:
            return "Column Number"
        case .LogMessage:
            return "Log Message"
        case .LogLevel:
            return "Log Level"
        case .Custom:
            return "Custom"
        }
    }
}

public typealias Static = RBStaticLoggerElement

extension String: RBLoggerElement {
    public var stringValue: String { return self }
    public var staticValue: RBStaticLoggerElement { return .Custom }
}

// MARK: Log Level
// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

public enum RBLoggerLevel {
    case Verbose, Debug, Info, Warning, Error
    
    var description: String {
        switch self {
        case .Verbose:
            return "Verbose"
        case .Debug:
            return "Debug"
        case .Info:
            return "Info"
        case .Warning:
            return "Warning"
        case .Error:
            return "Error"
        }
    }
}

// MARK: Colors
// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
public enum RBLoggerColorType {
    case Foreground, Background
}


// MARK: Class
// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

public class RBLogger {
    
    // MARK: Initializer
    static public let sharedLogger = RBLogger()
    public init() { }
    
    // MARK: - Settings
    public var logElements: [RBLoggerElement] = ["[", Static.LogLevel, "]", Static.FileName, Static.FunctionName, Static.LogMessage]
    public var logElementSeparator = " "
    
    public var enableXcodeColorsSupport = false
    public var logColors: [RBLoggerLevel: UIColor] = [
        .Verbose: UIColor.lightGrayColor(),
        .Debug: UIColor.purpleColor(),
        .Info: UIColor.greenColor(),
        .Warning: UIColor.orangeColor(),
        .Error: UIColor.redColor()
    ]
    
    // MARK: - XcodeColors
    static private let colorEscape = "\u{001b}["
    static private let colorReset = colorEscape + ";"
    static private let colorFgReset = colorEscape + "fg;"
    static private let colorBgReset = colorEscape + "bg;"
    
    private class func setColorString(forColor color: UIColor, type: RBLoggerColorType = .Foreground) -> String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return colorEscape + (type == RBLoggerColorType.Foreground ? "fg" : "bg") + "\(Int(r * 255.0)),\(Int(g * 255.0)),\(Int(b * 255.0));"
    }
    
    // MARK: - Logging
    public func log(level: RBLoggerLevel, message: String, _ function: String = __FUNCTION__, _ file: String = __FILE__, _ line: Int = __LINE__, _ column: Int =  __COLUMN__) {
        var logMessage = ""
        
        if enableXcodeColorsSupport {
            var theColor: UIColor! = logColors[level]
            if theColor == nil {
                theColor = UIColor.blackColor()
            }
            
            logMessage += RBLogger.setColorString(forColor: theColor)
        }
        
        for (index, element) in enumerate(logElements) {
            // Concatenate the current element:
            switch element.staticValue {
            case .FileName:
                logMessage += file.lastPathComponent
            case .FullFilePath:
                logMessage += file
            case .FunctionName:
                logMessage += function
            case .LineNumber:
                logMessage += String(line)
            case .ColumnNumber:
                logMessage += String(column)
            case .LogMessage:
                logMessage += message
            case .LogLevel:
                logMessage += level.description
            case .Custom:
                logMessage += element.stringValue
            }
            
            // Add separator if this isn't the last element
            if index != logElements.count - 1 {
                logMessage += logElementSeparator
            }
        }
        
        if enableXcodeColorsSupport {
            logMessage += RBLogger.colorReset
        }
        
        println(logMessage)
    }
    
    // MARK: - Convenience Logging
    public func verbose(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
        self.log(.Verbose, message: message, function, file, line, column)
    }
    
    public func debug(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
        self.log(.Debug, message: message, function, file, line, column)
    }
    
    public func info(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
        self.log(.Info, message: message, function, file, line, column)
    }
    
    public func warning(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
        self.log(.Warning, message: message, function, file, line, column)
    }
    
    public func error(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
        self.log(.Error, message: message, function, file, line, column)
    }
}

// MARK: - Fast Logging Using Shared Instance
public func RBVerbose(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
    RBLogger.sharedLogger.verbose(message, function: function, file: file, line: line, column: column)
}

public func RBDebug(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
    RBLogger.sharedLogger.debug(message, function: function, file: file, line: line, column: column)
}

public func RBInfo(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
    RBLogger.sharedLogger.info(message, function: function, file: file, line: line, column: column)
}

public func RBWarning(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
    RBLogger.sharedLogger.warning(message, function: function, file: file, line: line, column: column)
}

public func RBError(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
    RBLogger.sharedLogger.error(message, function: function, file: file, line: line, column: column)
}

// MARK: Operators (infix)
// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
infix operator >? { associativity left precedence 140 } // verbose
infix operator >! { associativity left precedence 140 } // debug
infix operator >* { associativity left precedence 140 } // info
infix operator >!? { associativity left precedence 140 } // warning
infix operator >!! { associativity left precedence 140 } // error

public func >?<T>(left: String, right: T) -> T {
    RBVerbose("\(left) \(right)", file: "", line: 0, column: 0)
    return right
}

public func >!<T>(left: String, right: T) -> T {
    RBDebug("\(left) \(right)", file: "", line: 0, column: 0)
    return right
}

public func >*<T>(left: String, right: T) -> T {
    RBInfo("\(left) \(right)", file: "", line: 0, column: 0)
    return right
}

public func >!?<T>(left: String, right: T) -> T {
    RBWarning("\(left) \(right)", file: "", line: 0, column: 0)
    return right
}

public func >!!<T>(left: String, right: T) -> T {
    RBError("\(left) \(right)", file: "", line: 0, column: 0)
    return right
}

// MARK: Operators (postfix)
// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
postfix operator <? {}
postfix operator <! {}
postfix operator <* {}
postfix operator <!? {}
postfix operator <!! {}

public postfix func <?<T>(printable: T) -> T {
    RBVerbose("\(printable)", file: "", line: 0, column: 0)
    return printable
}

public postfix func <!<T>(printable: T) -> T {
    RBDebug("\(printable)", file: "", line: 0, column: 0)
    return printable
}

public postfix func <*<T>(printable: T) -> T {
    RBInfo("\(printable)", file: "", line: 0, column: 0)
    return printable
}

public postfix func <!?<T>(printable: T) -> T {
    RBWarning("\(printable)", file: "", line: 0, column: 0)
    return printable
}

public postfix func <!!<T>(printable: T) -> T {
    RBError("\(printable)", file: "", line: 0, column: 0)
    return printable
}