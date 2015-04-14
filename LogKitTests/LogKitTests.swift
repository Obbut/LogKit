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
let testDest = TestLogDestination()

func assertMessage(expected: String, message: String) {
    XCTAssertEqual(testDest.lastMessage.loggableText, expected, message)
}

class LogKitTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        log.useForOperators()
        let coloredConsole = LogDestinationConsole()
        coloredConsole.encoder = XcodeColorsEncoder()
        log.destinations = [coloredConsole, testDest]
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLoggingSuffixOperators() {
        "This is a verbose logging test"<?
        assertMessage("[ Verbose ]  <? This is a verbose logging test", "Verbose logging operator output")
        
        "This is a debug logging test"<!
        assertMessage("[ Debug ]  <! This is a debug logging test", "Debug logging operator output")
        
        "This is a info logging test"<*
        assertMessage("[ Info ]  <* This is a info logging test", "Info logging operator output")
        
        "This is a warning logging test"<!?
        assertMessage("[ Warning ]  <!? This is a warning logging test", "Warning logging operator output")
        
        "This is a error logging test"<!!
        assertMessage("[ Error ]  <!! This is a error logging test", "Error logging operator output")
    }

    func testLoggingInfixOperators() {
        XCTAssertTrue("This should log true:" >? true, "Verbose infix operator")
        assertMessage("[ Verbose ]  >? This should log true: true", "Verbose infix operator output")
        
        XCTAssertFalse("This should log false:" >! false, "Debug infix operator")
        assertMessage("[ Debug ]  >! This should log false: false", "Debug infix operator output")
        
        XCTAssertEqual(55, "This should log 55:" >* 55, "Info infix operator")
        assertMessage("[ Info ]  >* This should log 55: 55", "Info infix operator output")
        
        XCTAssertTrue("Testing the warning operator:" >!? true, "Warning infix operator")
        assertMessage("[ Warning ]  >!? Testing the warning operator: true", "Warning infix operator output")
        
        XCTAssertFalse("Testing the error operator:" >!! false, "Error infix operator")
        assertMessage("[ Error ]  >!! Testing the error operator: false", "Error infix operator output")
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
        let dest = LogDestinationConsole()
        dest.encoder = XcodeColorsEncoder()
        myLogger.destinations = [dest]
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
    
    func testLoggingAttributedStrings() {
        let str = NSAttributedString(string: "This looks ugly", attributes: [
            NSForegroundColorAttributeName: UIColor.purpleColor(),
            NSBackgroundColorAttributeName: UIColor.yellowColor()
            ])
        log.verbose(str)
    }
    
    func testEmojiFormatter() {
        let emojiLogger = Logger()
        let dest = LogDestinationConsole()
        dest.formatters = [EmojiFormatter()]
        emojiLogger.destinations = [dest]
        
        emojiLogger.info("Hey hey :) This is a test of the Emoji logger ;) All these smileys should be automatically replaced.")
        emojiLogger.warning("Hopefully it works :|")
    }
}
