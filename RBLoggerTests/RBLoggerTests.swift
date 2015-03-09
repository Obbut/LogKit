//
//  RBLoggerTests.swift
//  RBLogger
//
//  Created by Robbert Brandsma on 27-02-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import UIKit
import XCTest
import RBLogger

class RBLoggerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
//                RBLogger.sharedLogger.enableXcodeColorsSupport = true
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoggingSuffixOperators() {
        "This is a verbose logging test"<?
        "This is a debug logging test"<!
        "This is a info logging test"<*
        "This is a warning logging test"<!?
        "This is a error logging test"<!!
    }
    
    func testLoggingInfixOperators() {
        XCTAssert("This should log true: " >? true, "Verbose infix operator")
        XCTAssertFalse("This should log false: " >! false, "Debug infix operator")
        XCTAssertEqual(55, "This should log 55: " >* 55, "Info infix operator")
        XCTAssert("Testing the Warning operator: " >!? true, "Warning infix operator")
        XCTAssertFalse("Testing the Error operator: " >!! false, "Error infix operator")
    }
    
    func testLoggingFunctions() {
        RBVerbose("This will be logged as verbose")
        RBDebug("This is a debug log message")
        RBInfo("This is an info log message")
        RBWarning("This is a warning message")
        RBError("And finally, an error log message")
    }
    
    func testCustomLogger() {
        let myLogger = RBLogger()
        myLogger.enableXcodeColorsSupport = true
        myLogger.logElements = ["Some static text in front...", Static.LogMessage, "and that was logged from file", Static.FileName]
        myLogger.info("Wooohooo info message")
        
        myLogger.logColors = [
            .Verbose: UIColor.yellowColor(),
            .Error: UIColor.greenColor()
        ]
        
        myLogger.error("This is an error message but it should be green")
        RBError("This however, should be red")
        
        myLogger.info("The color for this log level is undefined, so it should be black")
    }
    
}
