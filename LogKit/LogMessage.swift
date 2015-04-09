//
//  LogMessage.swift
//  LogKit
//
//  Created by Robbert Brandsma on 17-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public struct LogMessage {
    public init(text someText: NSAttributedString, logLevel aLevel: LogKitLevel, function aFunction: String, fullFilePath aFilePath: String, line aLine: Int, column aColumn: Int, elements someElements: [LogKitElement]) {
        attributedText = someText
        logLevel = aLevel
        function = aFunction
        fullFilePath = aFilePath
        line = aLine
        column = aColumn
        logElements = someElements
    }
    
    public init(text someText: String, logLevel aLevel: LogKitLevel, function aFunction: String, fullFilePath aFilePath: String, line aLine: Int, column aColumn: Int, elements someElements: [LogKitElement]) {
        let attrString = NSAttributedString(string: someText)
        self.init(text: attrString, logLevel: aLevel, function: aFunction, fullFilePath: aFilePath, line: aLine, column: aColumn, elements: someElements)
    }
    
    public var text: String {
        get {
            return attributedText.string
        }
        set {
            attributedText = NSAttributedString(string: text)
        }
    }
    
    public var attributedText: NSAttributedString
    public var logElements: [LogKitElement]
    
    public var attributedElementSepearator: NSAttributedString = NSAttributedString(string: " ")
    public var elementSeparator: String {
        get { return attributedElementSepearator.string }
        set { attributedElementSepearator = NSAttributedString(string: elementSeparator) }
    }
    
    public var logLevel: LogKitLevel
    public var attributedLogLevel: NSAttributedString { return NSAttributedString(string: logLevel.description) }
    
    public var function: String
    public var fullFilePath: String
    public var line: Int
    public var column: Int
    
    public var lineString: String { return String(line) }
    public var columnString: String { return String(column) }
    public var fileName: String { return fullFilePath.lastPathComponent }
    
    public var attributedFunction: NSAttributedString { return NSAttributedString(string: function) }
    public var attributedFullFilePath: NSAttributedString { return NSAttributedString(string: fullFilePath) }
    public var attributedFilename: NSAttributedString { return NSAttributedString(string: fileName) }
    public var attributedLine: NSAttributedString { return NSAttributedString(string: lineString) }
    public var attributedColumn: NSAttributedString { return NSAttributedString(string: columnString) }
    
    public var loggableText: String { return loggableAttributedText.string }
    
    public var loggableAttributedText: NSAttributedString {
        get {
            var loggableAttributedText = NSMutableAttributedString()
            
            for (index, element) in enumerate(renderedAttributedElements) {
                if index > 0 {
                    loggableAttributedText.appendAttributedString(attributedElementSepearator)
                }
                
                loggableAttributedText.appendAttributedString(element)
            }
            
            return loggableAttributedText
        }
    }
    
    public var renderedAttributedElements: [NSAttributedString] {
        get {
            var attributedElements = [NSAttributedString]()
            for element in logElements {
                switch element {
                case let .Static(text):
                    attributedElements += [NSAttributedString(string: text)]
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
    
    public var debugQuickLookObject: String {
        return self.loggableText
    }
}