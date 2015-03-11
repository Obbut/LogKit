# LogKit
LogKit is an easy to use logging library for Swift projects, written in Swift. It supports logging with operators, XcodeColors, customizable log messages and more. LogKit does not support Objective C projects.

## Usage

You can easily log trough a shared logger instance like this:

	let log = Logger() // Probably in your app delegate
	
	log.verbose("This will be logged as verbose")
	log.debug("This is a debug log message")
	log.info("This is an info log message")
	log.warning("This is a warning message")
	log.error("And finally, an error log message")

Which results in:

	[ Verbose ] LogKitTests.swift testLoggingFunctions() This will be logged as verbose
	[ Debug ] LogKitTests.swift testLoggingFunctions() This is a debug log message
	[ Info ] LogKitTests.swift testLoggingFunctions() This is an info log message
	[ Warning ] LogKitTests.swift testLoggingFunctions() This is a warning message
	[ Error ] LogKitTests.swift testLoggingFunctions() And finally, an error log message

Optionally, if you have XcodeColors installed, you can enable support for it like this:

	log.enableXcodeColorsSupport = true

If you don't like the standard logging markup you can change it to your taste:

	log.logElements = ["Some static text in front...", Static.LogMessage, "and that was logged from file", Static.FileName]

In the logElements array you can use the following values:

* Any standard string, which will be inserted as static text
* Static.FileName – The filename of the file from which is logged
* Static.FunctionName – The name of the function from which the log message was sent
* Static.LineNumber – The line number of the log message in the file
* Static.ColumnNumber – The number of the column of the log statement
* Static.LogMessage – The actual log message. If you don't include this, your log statements will become pretty useless.
* Static.LogLevel – The log level

The standard log elements array is:

	["[", Static.LogLevel, "]", Static.FileName, Static.FunctionName, Static.LogMessage]

### Logging Operators
You can also log with special logging operators. There are both infix and postfix logging operators.

__Infix Operators__

* `>?` for verbose logging
* `>!` for debug logging
* `>*` for info logging
* `>!?` for warning logging
* `>!!` for error logging

__Postfix operators__

* `<?` for verbose logging
* `<!` for debug logging
* `<*` for info logging
* `<!?` for warning logging
* `<!!` for error logging

The infix operators log the entity on the right side, prefixed by string on the left side. They return the right-hand entity and thus can be used inline. The postfix operators log the entity to which they are applied, and return the same entity, thus can be used inline.

	let exampleForLogging = "This string will be logged as info"<*

	if "The number is: " >* 4 == 4 {
		// This will always be executed
	}

	["Hello", "Cheese is green on tueseday", "Cookies"]<? // [ Verbose ]  <? [Hello, Cheese is green on tueseday, Cookies]

	NSProcessInfo().processName<* // Prints the process name

## License

LogKit is available under the MIT license. See the LICENSE file for more info.

## Changelog

### 0.2.0
* Rename from RBLogger to LogKit
* Changed the names of all classes, structs, etc

### 0.1.0
First version with the following features:

* Logging for 5 different log levels: verbose, debug, info, warning and error
* Infix logging operators for logging variables with a prefix (>?, >!, >*, >!?, >!!)
* Postfix logging operators for logging variables (<?, <!, <*, <!?, <!!)
* XcodeColors support
* Customizable log messages
* Customizable colors
* Logging trough multiple logging instances or the shared instance
