//
//  XcodeColorsTransformer.swift
//  LogKit
//
//  Created by Robbert Brandsma on 09-04-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public class XcodeColorsTransformer : LogMessageTransforming {
    public init() {}
    
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
    
    public func transform(message: NSMutableAttributedString) -> NSMutableAttributedString {
        let xcodeColorsText = NSMutableAttributedString(attributedString: message)
        
        var shiftedCharacters = 0
        message.enumerateAttributesInRange(NSRange(location: 0,length: message.length), options: .LongestEffectiveRangeNotRequired) {
            attrs, range, stop in
            
            var resetFgColor = false
            if let fgcolor = attrs[NSForegroundColorAttributeName] as? UIColor {
                resetFgColor = true
                let fgColorString = XcodeColorsTransformer.setColorString(forColor: fgcolor, attribute: NSForegroundColorAttributeName)
                xcodeColorsText.mutableString.insertString(fgColorString, atIndex: range.location + shiftedCharacters)
                shiftedCharacters += (fgColorString as NSString).length
            }
            
            var resetBgColor = false
            if let bgcolor = attrs[NSBackgroundColorAttributeName] as? UIColor {
                resetBgColor = true
                let bgColorString = XcodeColorsTransformer.setColorString(forColor: bgcolor, attribute: NSBackgroundColorAttributeName)
                xcodeColorsText.mutableString.insertString(bgColorString, atIndex: range.location + shiftedCharacters)
                shiftedCharacters += (bgColorString as NSString).length
            }
            
            if (resetFgColor) {
                xcodeColorsText.mutableString.insertString(XcodeColorsTransformer.colorFgReset, atIndex: range.location + range.length + shiftedCharacters)
                shiftedCharacters += (XcodeColorsTransformer.colorFgReset as NSString).length
            }
            
            if (resetBgColor) {
                xcodeColorsText.mutableString.insertString(XcodeColorsTransformer.colorBgReset, atIndex: range.location + range.length + shiftedCharacters)
                shiftedCharacters += (XcodeColorsTransformer.colorBgReset as NSString).length
            }
        }
        
        return xcodeColorsText
    }
}