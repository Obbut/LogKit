//
//  LogKitElement.swift
//  LogKit
//
//  Created by Robbert Brandsma on 18-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import UIKit

// MARK: Logger Element
// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

public enum LogKitElement {
    case FullFilePath, FileName, FunctionName, LineNumber, ColumnNumber, LogMessage, LogLevel
    case Static(String)
    
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
        case let .Static(text):
            return text
        case .LogMessage:
            return "Log Message"
        }
    }
}