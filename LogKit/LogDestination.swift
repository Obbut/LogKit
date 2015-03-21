//
//  LogDestination.swift
//  LogKit
//
//  Created by Robbert Brandsma on 17-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public class LogDestination {
    public init() {}
    public func log(message: LogMessage) { assertionFailure("You should not use the LogDestination class directly and you should override the log function in every subclass.") }
    public func didAttachToLogger(logger: Logger) {}
}