# Boat

[![CI Status](http://img.shields.io/travis/binku/Boat.svg?style=flat)](https://travis-ci.org/binku/Boat)
[![Version](https://img.shields.io/cocoapods/v/Boat.svg?style=flat)](http://cocoadocs.org/docsets/Boat)
[![License](https://img.shields.io/cocoapods/l/Boat.svg?style=flat)](http://cocoadocs.org/docsets/Boat)
[![Platform](https://img.shields.io/cocoapods/p/Boat.svg?style=flat)](http://cocoadocs.org/docsets/Boat)

## Usage

* Create a new project
* gem install cococapod
* gem install rboat
* pod init
* Add `pod 'Boat', :path => '/Users/bin/Codes/iphone/Boat'`
* pod install
* open ProjectName.xcodeproj then close ProjectName.xcworkspace
* open ProjectName.xcworkspace
* cd to new project and run `rboat` and enter project name
* Add below code to AppDelegate.rb
<pre>
    #import <Boat/Router.h>

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [Router redirectTo:@"HelloWorld" params:nil];
    [self.window makeKeyAndVisible];
</pre>

## Requirements

## Installation

Boat is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "Boat"

## Author

binku, binku87@gmail.com

## License

Boat is available under the MIT license. See the LICENSE file for more info.

