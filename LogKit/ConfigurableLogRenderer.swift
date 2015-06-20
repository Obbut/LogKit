//
//  ConfigurableLogRenderer.swift
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
- %framework
- %date

*/

func +=(left: NSMutableAttributedString, right: NSAttributedString) -> NSMutableAttributedString {
    left.appendAttributedString(right)
    return left
}

private extension NSMutableAttributedString {
    var range: NSRange { return NSRange(location: 0, length: self.string.characters.count) }
}

public struct LogColorSettings {
    var messageColor: UIColor?
    var levelColor: UIColor?
    
    var color: UIColor? {
        get { return messageColor == levelColor ? messageColor : nil }
        set { messageColor = newValue; levelColor = newValue }
    }
    
    public init() {}
    public init(color: UIColor) { self.color = color }
}

public class ConfigurableLogRenderer : LogMessageRendering, LogMessageTransformingSupported {
    
    public init() {}
    
    public var transformers = [LogMessageTransforming]()
    public var colors: [LogKitLevel: UIColor] = [
        .Verbose: .lightGrayColor(),
        .Debug: .purpleColor(),
        .Info: UIColor(red: 0, green: 0.6, blue: 0, alpha: 1),
        .Warning: .orangeColor(),
        .Error: .redColor()
    ]
    
    public var dateFormat: String {
        get { return dateFormatter.dateFormat }
        set { dateFormatter.dateFormat = newValue }
    }
    private lazy var dateFormatter: NSDateFormatter = {
        let dfm = NSDateFormatter()
        dfm.dateFormat = "HH:mm:ss"
        return dfm
    }()
    
    public lazy var attributedFormat: NSAttributedString = {
        var str = NSMutableAttributedString()
        
        str.appendAttributedString(NSAttributedString(string: "%date [%level] "))
        str.appendAttributedString(NSAttributedString(string: "%function ", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()]))
        str.appendAttributedString(NSAttributedString(string: "%message"))
        
        return str
    }()
    public var format: String {
        get { return attributedFormat.string }
        set { attributedFormat = NSAttributedString(string: newValue) }
    }
    
    public lazy var attributedFrameworkFormat: NSAttributedString? = {
        var str = NSMutableAttributedString()
        
        str.appendAttributedString(NSAttributedString(string: "%date [%level] "))
        str.appendAttributedString(NSAttributedString(string: "%framework ", attributes: [NSForegroundColorAttributeName: UIColor.purpleColor()]))
        str.appendAttributedString(NSAttributedString(string: "%message"))
        
        return str
    }()
    public var frameworkFormat: String? {
        get { return attributedFrameworkFormat?.string }
        set {
            if let val = newValue {
                attributedFrameworkFormat = NSAttributedString(string: val)
            } else {
                attributedFrameworkFormat = nil
            }
        }
    }
    
    public func render(message: LogMessage) -> NSAttributedString {
        let renderMessage: NSMutableAttributedString
        if let frameworkFormat = attributedFrameworkFormat, _ = message.frameworkIdentifier {
            renderMessage = NSMutableAttributedString(attributedString: frameworkFormat)
        } else {
            renderMessage = NSMutableAttributedString(attributedString: attributedFormat)
        }
        
        // DATE
        if let _ = renderMessage.string.rangeOfString("%date") {
            let dateString = dateFormatter.stringFromDate(message.date)
            renderMessage.mutableString.replaceOccurrencesOfString(
                "%date",
                withString: dateString,
                options: .LiteralSearch,
                range: renderMessage.range)
        }
        
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
        let messagePlaceholderRange = (renderMessage.string as NSString).rangeOfString("%message")
        if let messageColor = colors[message.logLevel] where messagePlaceholderRange.location != NSNotFound {
            renderMessage.addAttribute(NSForegroundColorAttributeName, value: messageColor, range: messagePlaceholderRange)
        }
        
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
        
        // FRAMEWORK
        let frameworkString = message.frameworkIdentifier ?? ""
        renderMessage.mutableString.replaceOccurrencesOfString(
            "%framework",
            withString: frameworkString,
            options: .LiteralSearch,
            range: renderMessage.range)
        
        var transformedMessage = renderMessage
        for tf in transformers { transformedMessage = tf.transform(transformedMessage) }
        
        return transformedMessage
    }
    
}