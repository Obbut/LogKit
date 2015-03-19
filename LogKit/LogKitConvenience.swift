//
//  LogKitConvenience.swift
//  LogKit
//
//  Created by Robbert Brandsma on 19-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

extension Logger {
    // MARK: - Convenience Logging with unattributed strings
    public func verbose(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
        self.log(.Verbose, message: message, function, file, line, column)
    }
    
    public func debug(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
        self.log(.Debug, message: message, function, file, line, column)
    }
    
    public func info(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
        self.log(.Info, message: message, function, file, line, column)
    }
    
    public func warning(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
        self.log(.Warning, message: message, function, file, line, column)
    }
    
    public func error(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
        self.log(.Error, message: message, function, file, line, column)
    }
    
    // MARK - Convenience Logging with attributed strings
    public func verbose(message: NSAttributedString, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
        self.log(.Verbose, message: message, function, file, line, column)
    }
    
    public func debug(message: NSAttributedString, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
        self.log(.Debug, message: message, function, file, line, column)
    }
    
    public func info(message: NSAttributedString, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
        self.log(.Info, message: message, function, file, line, column)
    }
    
    public func warning(message: NSAttributedString, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
        self.log(.Warning, message: message, function, file, line, column)
    }
    
    public func error(message: NSAttributedString, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int =  __COLUMN__) {
        self.log(.Error, message: message, function, file, line, column)
    }
}