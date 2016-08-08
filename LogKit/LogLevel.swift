//
//  LogLevel.swift
//  LogKit
//
//  Created by Robbert Brandsma on 19-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public enum LogKitLevel : CustomStringConvertible, Equatable, Comparable, Hashable {
    case verbose, debug, info, warning, error, custom(description: String)
    
    private var compareValue: Int {
        switch self {
        case .verbose:
            return 1
        case .debug:
            return 2
        case .info:
            return 3
        case .warning:
            return 4
        case .error:
            return 5
        case .custom(_):
            return 0
        }
    }
    
    public var hashValue: Int {
        return self.description.hashValue
    }
    
    public var description: String {
        switch self {
        case .verbose:
            return "Verbose"
        case .debug:
            return "Debug"
        case .info:
            return "Info"
        case .warning:
            return "Warning"
        case .error:
            return "Error"
        case .custom(let customValue):
            return customValue
        }
    }
}

public func ==(lhs: LogKitLevel, rhs: LogKitLevel) -> Bool {
    switch (lhs, rhs) {
    case (.verbose, .verbose), (.debug, .debug), (.info, .info), (.warning, .warning), (.error, .error):
        return true
    case (let .custom(leftCustom), let .custom(rightCustom)):
        return leftCustom == rightCustom
    default:
        return false
    }
}

public func <(left: LogKitLevel, right: LogKitLevel) -> Bool {
    return left.compareValue < right.compareValue
}
