//
//  EmojiFormatter.swift
//  LogKit
//
//  Created by Robbert Brandsma on 10-04-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public class EmojiFormatter: LogMessageFormatter {
    
    static var emojiMapping: [String: [String]] =
    [
        "😃": [":D"],
        "😊": [":)", "(:"],
        "😐": [":|"],
        "😉": [";)"],
        "😛": [":p"],
        "😶": [":x"],
        "❤️": ["<3"],
        "👍": ["(Y)"],
    ]
    
    override public func formatMessage(message: NSAttributedString) -> NSAttributedString {
        let mutableMessage = NSMutableAttributedString(attributedString: message)
        
        for (emoji, symbols) in EmojiFormatter.emojiMapping {
            for symbol in symbols {
                let range = (mutableMessage.string as NSString).rangeOfString(symbol, options: .CaseInsensitiveSearch)
                if range.location != NSNotFound {
                    mutableMessage.replaceCharactersInRange(range, withString: emoji)
                }
            }
        }
        
        return mutableMessage
    }
    
}