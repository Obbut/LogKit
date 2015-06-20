//
//  LogLevel.swift
//  LogKit
//
//  Created by Robbert Brandsma on 19-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public enum LogKitLevel: UInt, CustomStringConvertible, Comparable {
    case Verbose, Debug, Info, Warning, Error
    
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
        }
    }
}

public func <(left: LogKitLevel, right: LogKitLevel) -> Bool {
    return left.rawValue < right.rawValue
}