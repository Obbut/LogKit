//
//  LogLevel.swift
//  LogKit
//
//  Created by Robbert Brandsma on 19-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public enum LogKitLevel : CustomStringConvertible, Equatable, Comparable, Hashable {
    case Verbose, Debug, Info, Warning, Error, Custom(description: String)
    
    private var compareValue: Int {
        switch self {
        case .Verbose:
            return 1
        case .Debug:
            return 2
        case .Info:
            return 3
        case .Warning:
            return 4
        case .Error:
            return 5
        case .Custom(_):
            return 0
        }
    }
    
    public var hashValue: Int {
        return self.description.hashValue
    }
    
    public var description: String {
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
        case .Custom(let customValue):
            return customValue
        }
    }
}

public func ==(lhs: LogKitLevel, rhs: LogKitLevel) -> Bool {
    switch (lhs, rhs) {
    case (.Verbose, .Verbose), (.Debug, .Debug), (.Info, .Info), (.Warning, .Warning), (.Error, .Error):
        return true
    case (let .Custom(leftCustom), let .Custom(rightCustom)):
        return leftCustom == rightCustom
    default:
        return false
    }
}

public func <(left: LogKitLevel, right: LogKitLevel) -> Bool {
    return left.compareValue < right.compareValue
}