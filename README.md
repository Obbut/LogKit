# LogKit
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

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

## LogKit Protocols and Classes

### Classes

#### Logger
This is the central class of LogKit. You log your messages to an instance of this class. You configure it with one or more destinations. By default, it has one LogDestinationConsole.

#### FramworkLogger
When a framework asks for a logger trough `minimumLogLevelForFrameworkWithIdentifier(...)`, it is returned an instance of FrameworkLogger. A FrameworkLogger is essentially a proxy that filters and forwards messages to an instance of Logger that the user of your framework.

#### ConfigurableLogRenderer
A default log renderer that is supplied with LogKit. You can customize it in quite a bit of ways, or add transformers for an additional level of customization. This is the default renderer for use in LogKit and should be suitable for most cases.

#### XcodeColorsTransformer
XcodeColorsTransformer parses the foreground and background color attributes of the logged string, and inserts XcodeColors syntax in the right place.

#### EmojiTransformer
Replaces various smiley sequences, such as `:)`, `:|` or `<3` with emoji.

### Protocols

#### LogDestination
The LogDestination protocol defines a single function, `func log(message: LogMessage)`. You must implement this function to allow your class to accept log messages.

#### LogMessageRendering
A protocol that you can conform to in order to process instances of the `struct LogMessage` into an (attributed) string. Defines a single function: `func render(message: LogMessage) -> NSAttributedString`. In most situations, you probably don't need to create your own renderer but can use the ConfigurableLogRenderer that is supplied with LogKit.

#### LogRendererRequiring
Most LogDestinations will conform to this protocol. It indicates that they are not capable of rendering a log message by themselves, and need a renderer to transform log messages in readable text. Defines a simple property, `var renderer: LogMessageRendering { get set }`. You may not want to support this if you, for example, log to a network server and want all data to be preserved.

#### LogMessageTransforming
Allows you to create Log Message Transformers. A transformer can be used to modify rendered log messages. ConfigurableLogRenderer supports Transformers. LogKit uses transformers to allow you to output colors in the XcodeColors format, and supplies a transformer that converts some smiley sequences suc as `:)` into emoji.

#### LogMessageTransformingSupported
Conform to this protocol with your log renderer to indicate that you support transformers. When you conform to both the `LogMessageRendering` and the `LogMessageTransformingSupported` protocols, you get the following function for free: `func transform(message: NSAttributedString) -> NSMutableAttributedString`, which automatically runs the supplied log message trough all transformers.

## LogKit for Frameworks
LogKit has special support for frameworks. When developing a framework, you may want to incorporate logging for debugging purposes. However, users of your framework may or may not want your framework to log anything. With LogKit, your framework can request a special framework logging instance. You have to provide an identifier for your framework when requesting the logger.

The logger that your framework will use, is of the special _FrameworkLogger_ type. For you, as the client, the logging API works exactly the same. However, you cannot change any settings, add destinations, etcetera. This gives the user of your framework the ability to set various logging parameters on a per-framework basis.

Given the framework identifier, options like text attributes, minimum log levels or disabling logging overall can be configured for that specific framework. This gives a user very precise control over the log messages that your framework can and will emit.

## License

LogKit is available under the MIT license. See the LICENSE file for more info.

## Known Issues
* Attributed strings currently do not preserve their formatting when logged

## Upcoming Features
* LogKit Server
* Multithreading trough Grand Central Dispatch

## Changelog

### 0.6.0
* Removed logging operators
* Restructured a large part of the (internal, nonvisible) API and made LogKit a lot more Protocol-based
* Combined formatters and encoders into a single _Transformer_ protocol.
* Separated the concept of Log Message Rendering and Destinations
* Added ConfigurableLogRenderer, which uses a format string to configure how it outputs log messages (instead of an array)
* Added timestamps to logs
* Added support for logging from Frameworks
	* Frameworks can request an instance to use for logging
	* Host apps can configure which frameworks are allowed to log at which levels

### 0.5.0
* Converted LogKit to Swift 2.0

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
