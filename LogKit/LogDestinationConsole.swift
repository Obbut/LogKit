//
//  LogKitDestinationConsole.swift
//  LogKit
//
//  Created by Robbert Brandsma on 18-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import UIKit

public class LogDestinationConsole: LogDestination {
    // MARK: - XcodeColors
    static private let colorEscape = "\u{001b}["
    static private let colorReset = colorEscape + ";"
    static private let colorFgReset = colorEscape + "fg;"
    static private let colorBgReset = colorEscape + "bg;"
    
    private class func setColorString(forColor color: UIColor, attribute: String = NSForegroundColorAttributeName) -> String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let type: String
        switch attribute {
        case NSForegroundColorAttributeName:
            type = "fg"
        case NSBackgroundColorAttributeName:
            type = "bg"
        default:
            assertionFailure("Invalid setColorString attribute")
        }
        
        return colorEscape + type + "\(Int(r * 255.0)),\(Int(g * 255.0)),\(Int(b * 255.0));"
    }
    
    public var enableXcodeColorsSupport = false
    
    public override func log(message: LogMessage) {
        if enableXcodeColorsSupport == false {
            println(message.loggableText)
        } else {
            let attributedText = message.loggableAttributedText
            
            var xcodeColorsText = NSMutableString(string: attributedText.string)
            
            
            var shiftedCharacters = 0
            attributedText.enumerateAttributesInRange(NSRange(location: 0,length: attributedText.length), options: .LongestEffectiveRangeNotRequired) {
                attrs, range, stop in
                
                var resetFgColor = false
                if let fgcolor = attrs[NSForegroundColorAttributeName] as? UIColor {
                    resetFgColor = true
                    let fgColorString = LogDestinationConsole.setColorString(forColor: fgcolor, attribute: NSForegroundColorAttributeName)
                    xcodeColorsText.insertString(fgColorString, atIndex: range.location + shiftedCharacters)
                    shiftedCharacters += (fgColorString as NSString).length
                }
                
                var resetBgColor = false
                if let bgcolor = attrs[NSBackgroundColorAttributeName] as? UIColor {
                    resetBgColor = true
                    let bgColorString = LogDestinationConsole.setColorString(forColor: bgcolor, attribute: NSBackgroundColorAttributeName)
                    xcodeColorsText.insertString(bgColorString, atIndex: range.location + shiftedCharacters)
                    shiftedCharacters += (bgColorString as NSString).length
                }
                
                if (resetFgColor) {
                    xcodeColorsText.insertString(LogDestinationConsole.colorFgReset, atIndex: range.location + range.length + shiftedCharacters)
                    shiftedCharacters += (LogDestinationConsole.colorFgReset as NSString).length
                }
                
                if (resetBgColor) {
                    xcodeColorsText.insertString(LogDestinationConsole.colorBgReset, atIndex: range.location + range.length + shiftedCharacters)
                    shiftedCharacters += (LogDestinationConsole.colorBgReset as NSString).length
                }
            }
            
            println(xcodeColorsText)
        }
    }
}