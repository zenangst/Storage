![Storage logo](https://raw.githubusercontent.com/zenangst/Storage/master/Images/logo_v2.png)

[![CI Status](http://img.shields.io/travis/zenangst/Storage.svg?style=flat)](https://travis-ci.org/zenangst/Storage)
[![Version](https://img.shields.io/cocoapods/v/Storage.svg?style=flat)](http://cocoadocs.org/docsets/Storage)
[![License](https://img.shields.io/cocoapods/l/Storage.svg?style=flat)](http://cocoadocs.org/docsets/Storage)
[![Platform](https://img.shields.io/cocoapods/p/Storage.svg?style=flat)](http://cocoadocs.org/docsets/Storage)

## Usage

### Saving an object
```swift
Storage.save(object: object, "object.extension") { error in 
  if error != nil {
    // handle error
  }
}
```

### Loading an object from disk
```swift
let object = Storage.load("object.extension")
```

### Save contents to a file

```swift
Storage.save(contents: expectedString, "MyFile.txt") { error in
  XCTAssertNil(error)
}
```

### Load contents from a file

```swift
let contents = Storage.load(contentsAtPath: "MyFile.txt")
```

## Installation

**Storage** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Storage'
```

## Author

zenangst, chris@zenangst.com

## License

**Storage** is available under the MIT license. See the LICENSE file for more info.
