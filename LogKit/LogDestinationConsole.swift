//
//  LogKitDestinationConsole.swift
//  LogKit
//
//  Created by Robbert Brandsma on 18-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import UIKit

public class LogDestinationConsole: LogDestination {
    public override func log(message: String) {
        println(message)
    }
}