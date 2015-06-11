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
__Logging operators are disabled for now.__
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

Other features:
* Supports XcodeColors
* Internally based on NSAttributedStrings, which can also be logged. Available attributes depend on the destination.

## LogKit classes
LogKit consists of a number of classes, each of which serve a special purpose. An overview:

* __Logger__ This the main class in LogKit. It acts as a central hub for the logging framework, and you send your log messages to your logger.
* __LogDestination__ LogKit is flexible and can log to any number of destinations. By default, only one LogDestination of type LogDestinationConsole is configured. You can subclass this class to write your own log destination; this allows you to send your log messages over a network, write them to disk in a custom format, etcetera.
* __LogMessageEncoder__ You can optionally configure a log destination with an encoder. Encoders are subclasses of the LogMessageEncoder class, and their purpose is to take an attributed string and transform it to an ordinary string. LogKit provides a concrete subclass of LogMessageEncoder: XcodeColorsEncoder. Different log destinations can have different encoders.
* __LogMessageFormatter__ A formatter can replace parts of a log message or add attributes on it. It takes an attributed string, and returns the same or another attributed string. LogKit provides an implementation in the form of EmojiFormatter, that replaces common smiley sequences with Emoji.

## LogKit for Frameworks
LogKit has special support for frameworks. When developing a framework, you may want to incorporate logging for debugging purposes. However, users of your framework may or may not want your framework to log anything. With LogKit, your framework can request a special framework logging instance. You have to provide an identifier for your framework when requesting the logger.

The logger that your framework will use, is of the special _ProxyLogger_ type. For you, as the client, this works exactly the same as any other logger, except that you cannot create it yourself. Under the hood this gives the user of your framework the ability to set various logging parameters on a per-framework basis.

Given the framework identifier, options like text attributes, minimum log levels or disabling logging overall can be configured for that specific framework. This gives a user very precise control over the log messages that your framework can and will emit.

## License

LogKit is available under the MIT license. See the LICENSE file for more info.

## Upcoming Features
* LogKit Server
* Multithreading trough Grand Central Dispatch

## Changelog

### 0.4.0
* Added _Formatters_ and _Encoders_.
	* Formatters allow you to replace (e.g. format) parts of a string: replace characters, parse character sequences into NSAttributedString attributes, etc.
	* Encoders are the final step in the chain, and take an attributed string as input and a normal string as output. Use it to generate different log formats: HTML, Markdown, CSV, whatever you want.

### 0.3.0
* LogKit is now internally based on logging attributed strings. This means that you can add some markup to your logs, as long as your logging destination supports it.
* The output of logging is now handled by the LogDestination class. You can subclass it to send your log messages wherever you would want – Twitter, for example.

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
`