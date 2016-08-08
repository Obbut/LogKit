//
//  LogMessageEncoding.swift
//  LogKit
//
//  Created by Robbert Brandsma on 09-04-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public protocol LogMessageTransforming {
    func transform(_ message: NSMutableAttributedString) -> NSMutableAttributedString
}

public protocol LogMessageTransformingSupported {
    var transformers: [LogMessageTransforming] { get set }
}


public extension LogMessageRendering where Self : LogMessageTransformingSupported {
    
    public func transform(_ message: AttributedString) -> NSMutableAttributedString {
        var transformedMessage = NSMutableAttributedString(attributedString: message)
        for transformer in transformers { transformedMessage = transformer.transform(transformedMessage) }
        return transformedMessage
    }
    
}
