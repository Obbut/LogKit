//
//  LogKitDestinationConsole.swift
//  LogKit
//
//  Created by Robbert Brandsma on 18-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import UIKit

/// A concrete subclass of LogDestination that logs to the console using the Swift `print()` function.
public class LogDestinationConsole: LogDestination {
    public override func log(message: String) {
        print(message)
    }
}