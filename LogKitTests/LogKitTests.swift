//
//  LogKitTests.swift
//  LogKit
//
//  Created by Robbert Brandsma on 27-02-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import UIKit
import XCTest
import LogKit

let log = Logger()

class LogKitTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        log.enableXcodeColorsSupport = true
        log.useForOperators()
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
        log.verbose("This will be logged as verbose")
        log.debug("This is a debug log message")
        log.info("This is an info log message")
        log.warning("This is a warning message")
        log.error("And finally, an error log message")
    }

    func testCustomLogger() {
        let myLogger = Logger()
        myLogger.enableXcodeColorsSupport = true
        myLogger.logElements = [.Static("Some static text in front..."), .LogMessage, .Static("and that was logged from file"), .FileName]
        myLogger.info("Wooohooo info message")

        myLogger.logColors = [
            .Verbose: UIColor.yellowColor(),
            .Error: UIColor.greenColor()
        ]

        myLogger.error("This is an error message but it should be green")
        log.error("This however, should be red")

        myLogger.info("The color for this log level is undefined, so it should be black")
    }
    
    func testLogMessage() {
        var message = LogMessage(text: "text", logLevel: .Info, function: __FUNCTION__, fullFilePath: __FILE__, line: __LINE__, column: __COLUMN__, elements: [.LogLevel])
        XCTAssertEqual(message.loggableText, "Info", "Loglevel output not correct")
    }
}
