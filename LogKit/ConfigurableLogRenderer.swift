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

func +=(left: NSMutableAttributedString, right: AttributedString) -> NSMutableAttributedString {
    left.append(right)
    return left
}

private extension NSMutableAttributedString {
    var range: NSRange { return NSRange(location: 0, length: self.string.characters.count) }
}

public struct LogColorSettings {
    var messageColor: LKColor?
    var levelColor: LKColor?
    
    var color: LKColor? {
        get { return messageColor == levelColor ? messageColor : nil }
        set { messageColor = newValue; levelColor = newValue }
    }
    
    public init() {}
    public init(color: LKColor) { self.color = color }
}

public class ConfigurableLogRenderer : LogMessageRendering, LogMessageTransformingSupported {
    
    public init() {}
    
    public var transformers = [LogMessageTransforming]()
    public var colors: [LogKitLevel: LKColor] = [
        .verbose: .lightGray(),
        .debug: .purple(),
        .info: LKColor(red: 0, green: 0.6, blue: 0, alpha: 1),
        .warning: .orange(),
        .error: .red()
    ]
    
    public var dateFormat: String {
        get { return dateFormatter.dateFormat }
        set { dateFormatter.dateFormat = newValue }
    }
    private lazy var dateFormatter: DateFormatter = {
        let dfm = DateFormatter()
        dfm.dateFormat = "HH:mm:ss"
        return dfm
    }()
    
    public lazy var attributedFormat: AttributedString = {
        var str = NSMutableAttributedString()
        
        str.append(AttributedString(string: "%date [%level] "))
        str.append(AttributedString(string: "%function ", attributes: [NSForegroundColorAttributeName: LKColor.gray()]))
        str.append(AttributedString(string: "%message"))
        
        return str
    }()
    public var format: String {
        get { return attributedFormat.string }
        set { attributedFormat = AttributedString(string: newValue) }
    }
    
    public lazy var attributedFrameworkFormat: AttributedString? = {
        var str = NSMutableAttributedString()
        
        str.append(AttributedString(string: "%date [%level] "))
        str.append(AttributedString(string: "%framework ", attributes: [NSForegroundColorAttributeName: LKColor.purple()]))
        str.append(AttributedString(string: "%message"))
        
        return str
    }()
    public var frameworkFormat: String? {
        get { return attributedFrameworkFormat?.string }
        set {
            if let val = newValue {
                attributedFrameworkFormat = AttributedString(string: val)
            } else {
                attributedFrameworkFormat = nil
            }
        }
    }
    
    public func render(_ message: LogMessage) -> AttributedString {
        let renderMessage: NSMutableAttributedString
        if let frameworkFormat = attributedFrameworkFormat, _ = message.frameworkIdentifier {
            renderMessage = NSMutableAttributedString(attributedString: frameworkFormat)
        } else {
            renderMessage = NSMutableAttributedString(attributedString: attributedFormat)
        }
        
        // DATE
        if let _ = renderMessage.string.range(of: "%date") {
            let dateString = dateFormatter.string(from: message.date as Date)
            renderMessage.mutableString.replaceOccurrences(
                of: "%date",
                with: dateString,
                options: .literal,
                range: renderMessage.range)
        }
        
        // FULL FILE PATH
        renderMessage.mutableString.replaceOccurrences(
            of: "%fullfilepath",
            with: message.fullFilePath ?? "",
            options: .literal,
            range: renderMessage.range)
        
        // FILE NAME
        renderMessage.mutableString.replaceOccurrences(
            of: "%filename",
            with: message.fileName ?? "",
            options: .literal,
            range: renderMessage.range)
        
        // FUNCTION
        renderMessage.mutableString.replaceOccurrences(
            of: "%function",
            with: message.function ?? "",
            options: .literal,
            range: renderMessage.range)
        
        // LINE NUMBER
        renderMessage.mutableString.replaceOccurrences(
            of: "%line",
            with: String(message.line),
            options: .literal,
            range: renderMessage.range)
        
        // COLUMN NUMBER
        renderMessage.mutableString.replaceOccurrences(
            of: "%column",
            with: String(message.column),
            options: .literal,
            range: renderMessage.range)
        
        // LOG MESSAGE
        let messagePlaceholderRange = (renderMessage.string as NSString).range(of: "%message")
        if let messageColor = colors[message.logLevel] where messagePlaceholderRange.location != NSNotFound {
            renderMessage.addAttribute(NSForegroundColorAttributeName, value: messageColor, range: messagePlaceholderRange)
        }
        
        renderMessage.mutableString.replaceOccurrences(
            of: "%message",
            with: message.text,
            options: .literal,
            range: renderMessage.range)
        
        // LOG LEVEL
        renderMessage.mutableString.replaceOccurrences(
            of: "%level",
            with: message.logLevel.description,
            options: .literal,
            range: renderMessage.range)
        
        // FRAMEWORK
        let frameworkString = message.frameworkIdentifier ?? ""
        renderMessage.mutableString.replaceOccurrences(
            of: "%framework",
            with: frameworkString,
            options: .literal,
            range: renderMessage.range)
        
        var transformedMessage = renderMessage
        for tf in transformers { transformedMessage = tf.transform(transformedMessage) }
        
        return transformedMessage
    }
    
}
