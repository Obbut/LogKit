//
//  LogKitDestinationConsole.swift
//  LogKit
//
//  Created by Robbert Brandsma on 18-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

class LogDestinationConsole: LogDestination {
    func log(message: LogMessage) {
        println(message.loggableText)
    }
}