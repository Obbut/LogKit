//
//  TestLogDestination.swift
//  LogKit
//
//  Created by Robbert Brandsma on 19-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import LogKit

class TestLogDestination: LogDestination {
    var lastMessage: LogMessage!
    
    func log(message: LogMessage) {
        lastMessage = message
    }
}