//
//  ConfigurableRenderer.swift
//  LogKit
//
//  Created by Robbert Brandsma on 15-06-15.
//  Copyright © 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

/**
The format string can contain:

- %fullfilepath
- %filename
- %function
- %line
- %column
- %message
- %level

*/

func +=(left: NSMutableAttributedString, right: NSAttributedString) -> NSMutableAttributedString {
    left.appendAttributedString(right)
    return left
}

private extension NSMutableAttributedString {
    var range: NSRange { return NSRange(location: 0, length: self.string.characters.count) }
}

class ConfigurableLogRenderer : LogMessageRendering, LogMessageTransformingSupported {
    
    var transformers: [LogMessageTransforming] = []
    
    lazy var attributedFormat: NSAttributedString = {
        var str = NSMutableAttributedString()
        
        str.appendAttributedString(NSAttributedString(string: "[%level] "))
        str.appendAttributedString(NSAttributedString(string: "%filename:%line %function ", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()]))
        str.appendAttributedString(NSAttributedString(string: "%message"))
        
        return str
    }()
    
    var format: String {
        get { return attributedFormat.string }
        set { attributedFormat = NSAttributedString(string: newValue) }
    }
    
    func render(message: LogMessage) -> NSAttributedString {
        let renderMessage = NSMutableAttributedString(attributedString: attributedFormat)
        
        // FULL FILE PATH
        renderMessage.mutableString.replaceOccurrencesOfString(
            "%fullfilepath",
            withString: message.fullFilePath,
            options: .LiteralSearch,
            range: renderMessage.range)
        
        // FILE NAME
        renderMessage.mutableString.replaceOccurrencesOfString(
            "%filename",
            withString: message.fileName,
            options: .LiteralSearch,
            range: renderMessage.range)
        
        // FUNCTION
        renderMessage.mutableString.replaceOccurrencesOfString(
            "%function",
            withString: message.function,
            options: .LiteralSearch,
            range: renderMessage.range)
        
        // LINE NUMBER
        renderMessage.mutableString.replaceOccurrencesOfString(
            "%line",
            withString: String(message.line),
            options: .LiteralSearch,
            range: renderMessage.range)
        
        // COLUMN NUMBER
        renderMessage.mutableString.replaceOccurrencesOfString(
            "%column",
            withString: String(message.column),
            options: .LiteralSearch,
            range: renderMessage.range)
        
        // LOG MESSAGE
        renderMessage.mutableString.replaceOccurrencesOfString(
            "%message",
            withString: message.text,
            options: .LiteralSearch,
            range: renderMessage.range)
        
        // LOG LEVEL
        renderMessage.mutableString.replaceOccurrencesOfString(
            "%level",
            withString: message.logLevel.description,
            options: .LiteralSearch,
            range: renderMessage.range)
        
        return renderMessage
    }
    
}