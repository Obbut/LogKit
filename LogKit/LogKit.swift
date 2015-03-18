//
//  LogKit.swift
//  LogKit
//
//  Created by Robbert Brandsma on 27-02-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import UIKit

// MARK: Log Level
// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

public enum LogKitLevel {
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
public enum LogKitColorType {
    case Foreground, Background
}


// MARK: Class
// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

public class Logger {

    // MARK: Initializer
    public init() { }

    // MARK: - Settings
    public var logElements: [LogKitElement] = [.Static("["), .LogLevel, .Static("]"), .FileName, .FunctionName, .LogMessage]
    public var logElementSeparator = " "

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

    // MARK: - XcodeColors
    static private let colorEscape = "\u{001b}["
    static private let colorReset = colorEscape + ";"
    static private let colorFgReset = colorEscape + "fg;"
    static private let colorBgReset = colorEscape + "bg;"

    private class func setColorString(forColor color: UIColor, type: LogKitColorType = .Foreground) -> String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)

        return colorEscape + (type == LogKitColorType.Foreground ? "fg" : "bg") + "\(Int(r * 255.0)),\(Int(g * 255.0)),\(Int(b * 255.0));"
    }

    // MARK: - Logging
    public func log(level: LogKitLevel, message: String, _ function: String = __FUNCTION__, _ file: String = __FILE__, _ line: Int = __LINE__, _ column: Int =  __COLUMN__) {
        
        let logMessage = LogMessage(text: message, logLevel: level, function: function, fullFilePath: file, line: line, column: column, elements: self.logElements)
        
        for destination in self.destinations {
            destination.log(logMessage)
        }
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
    
    // Operator logging support
    public func useForOperators() {
        operatorLogger = self
    }
}

// MARK: Operator logging
// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

var operatorLogger: Logger?

// MARK: Operators (infix)
infix operator >? { associativity left precedence 140 } // verbose
infix operator >! { associativity left precedence 140 } // debug
infix operator >* { associativity left precedence 140 } // info
infix operator >!? { associativity left precedence 140 } // warning
infix operator >!! { associativity left precedence 140 } // error

public func >?<T>(left: String, right: T) -> T {
    operatorLogger!.verbose("\(left) \(right)", file: "", line: 0, column: 0)
    return right
}

public func >!<T>(left: String, right: T) -> T {
    operatorLogger!.debug("\(left) \(right)", file: "", line: 0, column: 0)
    return right
}

public func >*<T>(left: String, right: T) -> T {
    operatorLogger!.info("\(left) \(right)", file: "", line: 0, column: 0)
    return right
}

public func >!?<T>(left: String, right: T) -> T {
    operatorLogger!.warning("\(left) \(right)", file: "", line: 0, column: 0)
    return right
}

public func >!!<T>(left: String, right: T) -> T {
    operatorLogger!.error("\(left) \(right)", file: "", line: 0, column: 0)
    return right
}

// MARK: Operators (postfix)
postfix operator <? {}
postfix operator <! {}
postfix operator <* {}
postfix operator <!? {}
postfix operator <!! {}

public postfix func <?<T>(printable: T) -> T {
    operatorLogger!.verbose("\(printable)", file: "", line: 0, column: 0)
    return printable
}

public postfix func <!<T>(printable: T) -> T {
    operatorLogger!.debug("\(printable)", file: "", line: 0, column: 0)
    return printable
}

public postfix func <*<T>(printable: T) -> T {
    operatorLogger!.info("\(printable)", file: "", line: 0, column: 0)
    return printable
}

public postfix func <!?<T>(printable: T) -> T {
    operatorLogger!.warning("\(printable)", file: "", line: 0, column: 0)
    return printable
}

public postfix func <!!<T>(printable: T) -> T {
    operatorLogger!.error("\(printable)", file: "", line: 0, column: 0)
    return printable
}
