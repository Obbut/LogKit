//
//  LogKitOperators.swift
//  LogKit
//
//  Created by Robbert Brandsma on 19-03-15.
//  Copyright (c) 2015 Robbert Brandsma. All rights reserved.
//

import Foundation

var operatorLogger: Logger?

extension Logger {
    // Operator logging support
    public func useForOperators() {
        operatorLogger = self
    }
}

// MARK: Operators (infix)
infix operator >? { associativity left precedence 140 } // verbose
infix operator >! { associativity left precedence 140 } // debug
infix operator >* { associativity left precedence 140 } // info
infix operator >!? { associativity left precedence 140 } // warning
infix operator >!! { associativity left precedence 140 } // error

public func >?<T>(left: String, right: T) -> T {
    operatorLogger!.verbose("\(left) \(right)", file: "", line: 0, column: 0)
    return right
}

public func >!<T>(left: String, right: T) -> T {
    operatorLogger!.debug("\(left) \(right)", file: "", line: 0, column: 0)
    return right
}

public func >*<T>(left: String, right: T) -> T {
    operatorLogger!.info("\(left) \(right)", file: "", line: 0, column: 0)
    return right
}

public func >!?<T>(left: String, right: T) -> T {
    operatorLogger!.warning("\(left) \(right)", file: "", line: 0, column: 0)
    return right
}

public func >!!<T>(left: String, right: T) -> T {
    operatorLogger!.error("\(left) \(right)", file: "", line: 0, column: 0)
    return right
}

// MARK: Operators (postfix)
postfix operator <? {}
postfix operator <! {}
postfix operator <* {}
postfix operator <!? {}
postfix operator <!! {}

public postfix func <?<T>(printable: T) -> T {
    operatorLogger!.verbose("\(printable)", file: "", line: 0, column: 0)
    return printable
}

public postfix func <!<T>(printable: T) -> T {
    operatorLogger!.debug("\(printable)", file: "", line: 0, column: 0)
    return printable
}

public postfix func <*<T>(printable: T) -> T {
    operatorLogger!.info("\(printable)", file: "", line: 0, column: 0)
    return printable
}

public postfix func <!?<T>(printable: T) -> T {
    operatorLogger!.warning("\(printable)", file: "", line: 0, column: 0)
    return printable
}

public postfix func <!!<T>(printable: T) -> T {
    operatorLogger!.error("\(printable)", file: "", line: 0, column: 0)
    return printable
}