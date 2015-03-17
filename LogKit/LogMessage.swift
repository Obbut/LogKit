//
//  LogMessage.swift
//  LogKit
//
//  Created by Robbert Brandsma on 17-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public struct LogMessage {
    var text: String {
        get {
            return attributedText.string
        }
        set {
            attributedText = NSAttributedString(string: text)
        }
    }
    
    var attributedText: NSAttributedString
    var logElements: [LogKitElement]
    
    var logLevel: LogKitLevel
    var attributedLogLevel: NSAttributedString { return NSAttributedString(string: logLevel.description) }
    
    var function: String
    var fullFilePath: String
    var line: Int
    var column: Int
    
    var lineString: String { return String(line) }
    var columnString: String { return String(column) }
    var fileName: String { return fullFilePath.lastPathComponent }
    
    var attributedFunction: NSAttributedString { return NSAttributedString(string: function) }
    var attributedFullFilePath: NSAttributedString { return NSAttributedString(string: fullFilePath) }
    var attributedFilename: NSAttributedString { return NSAttributedString(string: fileName) }
    var attributedLine: NSAttributedString { return NSAttributedString(string: lineString) }
    var attributedColumn: NSAttributedString { return NSAttributedString(string: columnString) }
    
    var loggableText: String { return loggableAttributedText.string }
    
    var loggableAttributedText: NSAttributedString {
        get {
            var loggableAttributedText = NSMutableAttributedString()
            
            for element: NSAttributedString in renderedAttributedElements {
                loggableAttributedText.appendAttributedString(element)
            }
            
            return loggableAttributedText
        }
    }
    
    var renderedAttributedElements: [NSAttributedString] {
        get {
            var attributedElements = [NSAttributedString]()
            for element: LogKitElement in logElements {
                switch element.staticValue {
                case .Contained:
                    attributedElements += [NSAttributedString(string: element.stringValue)]
                case .FileName:
                    attributedElements += [attributedFilename]
                case .FullFilePath:
                    attributedElements += [attributedFullFilePath]
                case .FunctionName:
                    attributedElements += [attributedFunction]
                case .LineNumber:
                    attributedElements += [attributedLine]
                case .ColumnNumber:
                    attributedElements += [attributedColumn]
                case .LogMessage:
                    attributedElements += [attributedText]
                case .LogLevel:
                    attributedElements += [attributedLogLevel]
                }
            }
            return attributedElements
        }
    }
}