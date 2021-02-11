# viacep-ios

[![CI Status](https://img.shields.io/travis/regis@r3tecnologia.net/viacep-ios.svg?style=flat)](https://travis-ci.org/regis@r3tecnologia.net/viacep-ios)
[![Version](https://img.shields.io/cocoapods/v/viacep-ios.svg?style=flat)](https://cocoapods.org/pods/viacep-ios)
[![License](https://img.shields.io/cocoapods/l/viacep-ios.svg?style=flat)](https://cocoapods.org/pods/viacep-ios)
[![Platform](https://img.shields.io/cocoapods/p/viacep-ios.svg?style=flat)](https://cocoapods.org/pods/viacep-ios)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

viacep-ios is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'viacep-ios'
```

## Usage

```swift
let viaCep = Viacep(cep: cep.text)
        if viaCep.hasErrorCep() {
            debugPrint("Error format cep")
        } else {
            viaCep.requestCep( {(error, address) -> Void in
                if (error != nil) {
                    debugPrint("erro = \(error.debugDescription)")
                } else {
                    debugPrint(address.debugDescription)
                    self.address = address
                }
            })
            
        }
```


## Author

Regis Araujo Melo, regis@r3tecnologia.net

## License

viacep-ios is available under the MIT license. See the LICENSE file for more info.
