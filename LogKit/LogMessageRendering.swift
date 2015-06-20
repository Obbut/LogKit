//
//  LogMessageRendering.swift
//  LogKit
//
//  Created by Robbert Brandsma on 15-06-15.
//  Copyright © 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public protocol LogMessageRendering {
    func render(message: LogMessage) -> NSAttributedString
}

public protocol LogRendererRequiring {
    var renderer: LogMessageRendering { get set }
}