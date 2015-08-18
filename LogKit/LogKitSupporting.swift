//
//  LogKitSupporting.swift
//  LogKit
//
//  Created by Robbert Brandsma on 18-08-15.
//  Copyright © 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

#if os(OSX)
    public typealias LKColor = NSColor
#else
    public typealias LKColor = UIColor
#endif

