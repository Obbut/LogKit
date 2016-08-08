//
//  LogDestination.swift
//  LogKit
//
//  Created by Robbert Brandsma on 17-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//



import Foundation

public protocol LogDestination {
    func log(_ message: LogMessage)
}
