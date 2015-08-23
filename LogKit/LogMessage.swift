//
//  LogMessage.swift
//  LogKit
//
//  Created by Robbert Brandsma on 17-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public struct LogMessage {
    public init(text someText: NSAttributedString, logLevel aLevel: LogKitLevel, function aFunction: String? = nil, fullFilePath aFilePath: String? = nil, line aLine: Int? = nil, column aColumn: Int? = nil, frameworkIdentifier anIdentifier: String? = nil) {
        attributedText = someText
        logLevel = aLevel
        function = aFunction
        fullFilePath = aFilePath
        line = aLine
        column = aColumn
        frameworkIdentifier = anIdentifier
    }
    
    public init(text someText: String, logLevel aLevel: LogKitLevel, function aFunction: String? = nil, fullFilePath aFilePath: String? = nil, line aLine: Int? = nil, column aColumn: Int? = nil, frameworkIdentifier anIdentifier: String? = nil) {
        let attrString = NSAttributedString(string: someText)
        self.init(text: attrString, logLevel: aLevel, function: aFunction, fullFilePath: aFilePath, line: aLine, column: aColumn, frameworkIdentifier: anIdentifier)
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
    public var logLevel: LogKitLevel
    
    public var function: String?
    public var fullFilePath: String?
    public var line: Int?
    public var column: Int?
    public var frameworkIdentifier: String?
    public var date = NSDate()
    
    public var fileName: String? { return (fullFilePath as NSString?)?.lastPathComponent }
}