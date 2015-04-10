//
//  XcodeColorsEncoder.swift
//  LogKit
//
//  Created by Robbert Brandsma on 09-04-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public class XcodeColorsEncoder : LogMessageEncoder {
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
            return ""
        }
        
        return colorEscape + type + "\(Int(r * 255.0)),\(Int(g * 255.0)),\(Int(b * 255.0));"
    }
    
    override public func encodeLogMessage(message: NSAttributedString) -> String {
        var xcodeColorsText = NSMutableString(string: message.string)
        
        
        var shiftedCharacters = 0
        message.enumerateAttributesInRange(NSRange(location: 0,length: message.length), options: .LongestEffectiveRangeNotRequired) {
            attrs, range, stop in
            
            var resetFgColor = false
            if let fgcolor = attrs[NSForegroundColorAttributeName] as? UIColor {
                resetFgColor = true
                let fgColorString = XcodeColorsEncoder.setColorString(forColor: fgcolor, attribute: NSForegroundColorAttributeName)
                xcodeColorsText.insertString(fgColorString, atIndex: range.location + shiftedCharacters)
                shiftedCharacters += (fgColorString as NSString).length
            }
            
            var resetBgColor = false
            if let bgcolor = attrs[NSBackgroundColorAttributeName] as? UIColor {
                resetBgColor = true
                let bgColorString = XcodeColorsEncoder.setColorString(forColor: bgcolor, attribute: NSBackgroundColorAttributeName)
                xcodeColorsText.insertString(bgColorString, atIndex: range.location + shiftedCharacters)
                shiftedCharacters += (bgColorString as NSString).length
            }
            
            if (resetFgColor) {
                xcodeColorsText.insertString(XcodeColorsEncoder.colorFgReset, atIndex: range.location + range.length + shiftedCharacters)
                shiftedCharacters += (XcodeColorsEncoder.colorFgReset as NSString).length
            }
            
            if (resetBgColor) {
                xcodeColorsText.insertString(XcodeColorsEncoder.colorBgReset, atIndex: range.location + range.length + shiftedCharacters)
                shiftedCharacters += (XcodeColorsEncoder.colorBgReset as NSString).length
            }
        }
        
        return xcodeColorsText as String
    }
}