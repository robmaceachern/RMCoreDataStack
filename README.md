# RMCoreDataStack

[![Version](https://img.shields.io/cocoapods/v/RMCoreDataStack.svg?style=flat)](http://cocoadocs.org/docsets/RMCoreDataStack)
[![License](https://img.shields.io/cocoapods/l/RMCoreDataStack.svg?style=flat)](http://cocoadocs.org/docsets/RMCoreDataStack)
[![Platform](https://img.shields.io/cocoapods/p/RMCoreDataStack.svg?style=flat)](http://cocoadocs.org/docsets/RMCoreDataStack)

## Usage

### In your own project

1. Install via [CocoaPods](http://cocoapods.org/)
	
	```
	pod 'RMCoreDataStack'
	```
2. Import the public header

	```
	#import <RMCoreDataStack/RMCoreDataStack.h>
	```
3. Setup your stack

    ```
    self.coreDataStack = [[RMCoreDataStack alloc] init];
    self.coreDataStack.delegate = self;
    [self.coreDataStack constructWithConfiguration:nil];
    ```
    
4. Grab the NSManagedObject context and start persisting!

    ```
    NSManagedObjectContext context = self.coreDataStack.managedObjectContext;
    // pass context to your custom objects and view controllers
    ```
    
If you need to customize the configuration of the core data stack you can do so by creating an ```RMCoreDataConfiguration``` and passing it to the ```constructWithConfiguration:``` method.

### Demo project

To run the example project, clone the repo, and run `pod install` from the Example directory first.

The BasicDemo is based on the Xcode Master-Detail Application template. The only changes are in RMAppDelegate.

## Requirements

The project is currently configured to support iOS 7 and higher. OSX is not currently supported but it will be soon.

## Installation

RMCoreDataStack is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "RMCoreDataStack"

## Author

Rob MacEachern, rob@robmaceachern.com

## License

RMCoreDataStack is available under the MIT license. See the LICENSE file for more info.

