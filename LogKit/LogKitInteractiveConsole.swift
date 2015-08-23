//
//  LogKitConsole.swift
//  LogKit
//
//  Created by Robbert Brandsma on 21-08-15.
//  Copyright © 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

public class InteractiveConsole : LogDestinationConsole {
    public var commands = [ConsoleCommand]()
    
    public func write(text: String) {
        let logMessage = LogMessage(text: text, logLevel: LogKitLevel.Custom(description: text))
        self.log(logMessage)
    }
    
    public func parseNext() {
        var input: String?
        
        repeat {
            input = readLine()
        } while input == nil
        
        // find the command
        for command in commands {
            if command.name == input! {
                command.action()
                return
            }
        }
        
        self.write("Command not found")
    }
}

public struct ConsoleCommand {
    var name: String
    var helpText: String?
    var action: () -> ()
    
    public init(name: String, action: () -> ()) {
        self.name = name
        self.action = action
    }
}