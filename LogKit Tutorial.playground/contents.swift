import LogKit
/*:
# Welcome to LogKit!
LogKit is a flexible new logging framework written in Swift. It allows for custom log message formatting, support for rich text output, logging to a remote server or a custom destination, _customizable log levels and remote configuration_.

This tutorial was last updated for LogKit 0.4.0.

## About this Playground
This playground shows you various ways to use LogKit. To view the results, click the 'Show result' button next to a statement in the results area (image below). Alternatively, you can also view console output by opening the assistant editor by pressing ⌥⌘↩.

![Show Results button](ResultsButton.png "Show Results")

------------------------------------

To get started with LogKit, you will need an instance of the __Logger__ class. It serves as the manager and destination for all your log messages and is fully configurable.
*/
let log = Logger()
log.playgroundMode = true
/*:
Playground mode enables black magic, so the results can be shown inline. You shouldn't enable it when using LogKit in an app, but it is very useful in playgrounds.

After creating our logging object, we can immediately start printing log messages:
*/
log.warning("Hello, World!")
/*:
## Logging Destinations

However, the most common log destination is probably the console. LogKit has a __LogDestination__ abstract class and comes with an implementation in the form of __LogDestinationConsole__ by default.

### XcodeColors Support in LogDestinationConsole
By default, color codes and other attributes will not be displayed in the console. However, if you have [XcodeColors](https://github.com/robbiehanson/XcodeColors) installed, you can uncomment the following lines by selecting them and pressing ⌘/ to enable colors in the Xcode Console:
*/
let coloredConsole = LogDestinationConsole()
//coloredConsole.enableXcodeColorsSupport = true
log.destinations = [coloredConsole]
log.warning("This should print in orange!")
/*:
XcodeColors will greatly improve your LogKit Experience and is highly recommended. To show the results, open the assistant editor by pressing ⌥⌘↩ or from View > Assistant Editor > Show Assistant Editor. Make sure the assistant editor is set to 'Timeline'.

------------------------------------

## Log Levels

LogKit currently has built-in support for 5 levels of logging: verbose, debug, info, warning and error.
*/
log.verbose("Verbose messages are printed in gray")
log.debug("Debug messages are printed in purple")
log.info("Info messages are printed in green")
log.warning("Warning messages are printed in orange")
log.error("And finally, error messages are printed in red")
/*:
Should you wish to do so, you can also print attributed strings. For console output with XcodeColors, only the foreground color and background color can be changed.
*/
let attributedString = NSAttributedString(string: "Hello!", attributes: [NSForegroundColorAttributeName: UIColor.cyanColor(),
    NSBackgroundColorAttributeName: UIColor.blackColor()])
log.info(attributedString)

