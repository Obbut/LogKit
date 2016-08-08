//
//  LogKitDestinationConsole.swift
//  LogKit
//
//  Created by Robbert Brandsma on 18-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

/// A concrete subclass of LogDestination that logs to the console using the Swift `print()` function.
public class LogDestinationConsole: LogDestination, LogRendererRequiring {
    public init() {}
    
    public lazy var renderer: LogMessageRendering = ConfigurableLogRenderer()
    
    public func log(_ message: LogMessage) {
        print(renderer.render(message).string)
    }
}
