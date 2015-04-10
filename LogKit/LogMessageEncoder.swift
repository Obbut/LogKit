//
//  LogKitFormatter.swift
//  LogKit
//
//  Created by Robbert Brandsma on 09-04-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public class LogMessageEncoder {
    public init() {}
    
    public func encodeLogMessage(message: NSAttributedString) -> String {
        return message.string
    }
}