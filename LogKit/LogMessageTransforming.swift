//
//  LogMessageEncoding.swift
//  LogKit
//
//  Created by Robbert Brandsma on 09-04-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public protocol LogMessageTransforming {
    func transform(message: NSAttributedString) -> NSAttributedString
}

public protocol LogMessageTransformingSupported {
    var transformers: [LogMessageTransforming] { get set }
}


public extension LogMessageRendering where Self : LogMessageTransformingSupported {
    
    public func transform(message: NSAttributedString) -> NSAttributedString {
        var transformedMessage = message
        for transformer in transformers { transformedMessage = transformer.transform(transformedMessage) }
        return transformedMessage
    }
    
}