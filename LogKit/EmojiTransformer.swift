//
//  EmojiFormatter.swift
//  LogKit
//
//  Created by Robbert Brandsma on 10-04-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public class EmojiTransformer: LogMessageTransforming {
    public init() {}
    
    static let emojiMapping =
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
    
    public func transform(message: NSMutableAttributedString) -> NSMutableAttributedString {
        for (emoji, symbols) in EmojiTransformer.emojiMapping {
            for symbol in symbols {
                let range = (message.string as NSString).rangeOfString(symbol, options: .CaseInsensitiveSearch)
                if range.location != NSNotFound {
                    message.replaceCharactersInRange(range, withString: emoji)
                }
            }
        }
        
        return message
    }
    
}