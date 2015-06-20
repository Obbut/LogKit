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

func assertMessage(expected: String, message: String) {
//    XCTAssertEqual(testDest.lastMessage.loggableText, expected, message)
}

class LogKitTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        log.destinations = [XcodeColorsConsoleDestination()]
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLoggingFunctions() {
        log.verbose("This will be logged as verbose")
        log.debug("This is a debug log message")
        log.info("This is an info log message")
        log.warning("This is a warning message")
        log.error("And finally, an error log message")
    }

//    func testCustomLogger() {
//        let myLogger = Logger()
//        let dest = LogDestinationConsole()
//        dest.encoder = XcodeColorsEncoder()
//        myLogger.destinations = [dest]
//        myLogger.logElements = [.Static("Some static text in front..."), .LogMessage, .Static("and that was logged from file"), .FileName]
//        myLogger.info("Wooohooo info message")
//
//        myLogger.logColors = [
//            .Verbose: UIColor.yellowColor(),
//            .Error: UIColor.greenColor()
//        ]
//
//        myLogger.error("This is an error message but it should be green")
//        log.error("This however, should be red")
//
//        myLogger.info("The color for this log level is undefined, so it should be black")
//    }
    
//    func testLogMessage() {
//        let message = LogMessage(text: "text", logLevel: .Info, function: __FUNCTION__, fullFilePath: __FILE__, line: __LINE__, column: __COLUMN__, elements: [.LogLevel])
//        XCTAssertEqual(message.loggableText, "Info", "Loglevel output not correct")
//    }
    
//    func testLoggingAttributedStrings() {
//        let str = NSAttributedString(string: "This looks ugly", attributes: [
//            NSForegroundColorAttributeName: UIColor.purpleColor(),
//            NSBackgroundColorAttributeName: UIColor.yellowColor()
//            ])
//        log.verbose(str)
//        XCTFail("Attributed string logging does not work")
//    }
    
    func testEmojiTransformer() {
        let emojiLogger = Logger()
        let dest = LogDestinationConsole()
        let ren = ConfigurableLogRenderer()
        ren.transformers = [EmojiTransformer(), XcodeColorsTransformer()]
        dest.renderer = ren
        
        emojiLogger.destinations = [dest]
        
        emojiLogger.info("Hey hey :) This is a test of the Emoji logger ;) All these smileys should be automatically replaced. :)")
        emojiLogger.warning("Hopefully it works :|")
    }
    
    func testForFrameworks() {
        let fwl = Logger.loggerForFrameworkWithIdentifier("com.robbertbrandsma.test")
        fwl.warning("With the default configuration, this should be readable!")
        fwl.debug("This however, should NOT be readable with the deafault configuration.")
        
        log.setMinimumLogLevel(.Warning, forFrameworkWithIdentifier: "com.robbertbrandsma.test")
        
        fwl.warning("This should be readable")
        fwl.info("This should not be readable.")
    }
}
