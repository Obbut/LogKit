//
//  LogKitElement.swift
//  LogKit
//
//  Created by Robbert Brandsma on 18-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

// MARK: Logger Element
// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

public protocol LogKitElement {
    var stringValue: String { get }
    var staticValue: LogKitStaticElement { get }
}

public enum LogKitStaticElement: LogKitElement {
    case FullFilePath, FileName, FunctionName, LineNumber, ColumnNumber, LogMessage, LogLevel, Contained
    
    public var stringValue: String { return self.description }
    public var staticValue: LogKitStaticElement { return self }
    
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
        case .LogLevel:
            return "Log Level"
        case .Contained:
            return "Contained"
        case .LogMessage:
            return "Log Message"
        }
    }
}

public typealias Static = LogKitStaticElement

extension String: LogKitElement {
    public var stringValue: String { return self }
    public var staticValue: LogKitStaticElement { return .Contained }
}