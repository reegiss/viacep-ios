# viacep-ios

[![CI Status](https://img.shields.io/travis/regis@r3tecnologia.net/viacep-ios.svg?style=flat)](https://travis-ci.org/regis@r3tecnologia.net/viacep-ios)
[![Version](https://img.shields.io/cocoapods/v/viacep-ios.svg?style=flat)](https://cocoapods.org/pods/viacep-ios)
[![License](https://img.shields.io/cocoapods/l/viacep-ios.svg?style=flat)](https://cocoapods.org/pods/viacep-ios)
[![Platform](https://img.shields.io/cocoapods/p/viacep-ios.svg?style=flat)](https://cocoapods.org/pods/viacep-ios)

A modern Swift library for fetching Brazilian postal code (CEP) information using the ViaCEP API.

## Features

- ✨ Modern async/await API (Swift 5.5+)
- 🔄 Backward compatible with completion handlers
- 🎯 Type-safe error handling
- 🧵 Thread-safe with Actor isolation
- 📱 iOS 13+, macOS 10.15+, tvOS 13+, watchOS 6+
- 📝 Comprehensive documentation
- ✅ Well-tested

## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 5.6+
- Xcode 13.0+

## Installation

viacep-ios is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'viacep-ios'
```

Or use Swift Package Manager by adding this to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/reegiss/viacep-ios.git", from: "1.0.0")
]
```

## Usage

### Modern Async/Await (Recommended)

```swift
import Viacep

// Create a client instance
let client = ViacepClient()

// Fetch address using async/await
Task {
    do {
        let address = try await client.fetchAddress(cep: "01001000")
        print("Address: \(address.logradouro), \(address.localidade) - \(address.uf)")
    } catch let error as ViacepError {
        print("Error: \(error.localizedDescription)")
    }
}
```

### Completion Handler API

```swift
import Viacep

let client = ViacepClient()

client.fetchAddress(cep: "01001000") { result in
    switch result {
    case .success(let address):
        print("Address: \(address.logradouro)")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}
```

### CEP Validation

```swift
// Validate CEP format before making request
if ViacepClient.isValidCEP("01001000") {
    // CEP is valid (8 digits)
    // Proceed with request
}
```

### Error Handling

The library provides detailed error types:

```swift
do {
    let address = try await client.fetchAddress(cep: "12345")
} catch ViacepError.invalidCEP {
    print("Invalid CEP format")
} catch ViacepError.networkError(let error) {
    print("Network error: \(error)")
} catch ViacepError.decodingError(let error) {
    print("Failed to decode response: \(error)")
} catch {
    print("Unknown error: \(error)")
}
```

### Dependency Injection

For testing or custom configurations:

```swift
// Custom URLSession configuration
let configuration = URLSessionConfiguration.default
configuration.timeoutIntervalForRequest = 30
let session = URLSession(configuration: configuration)

let service = ViacepService(urlSession: session)
let client = ViacepClient(service: service)
```

## Legacy API (Deprecated)

The old API is still supported for backward compatibility:

```swift
let viaCep = Viacep(cep: "01001000")

if viaCep.hasErrorCep() {
    print("Error: Invalid CEP format")
} else {
    viaCep.requestCep { (error, address) in
        if let error = error {
            print("Error: \(error)")
        } else if let address = address {
            print("Address: \(address.logradouro)")
        }
    }
}
```

**Note:** The legacy API is deprecated. Please migrate to the modern API shown above.

## Example Project

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Migration Guide

### From Old API to New API

**Before:**
```swift
let viaCep = Viacep(cep: "01001000")
viaCep.requestCep { (error, address) in
    if let error = error {
        print("Error: \(error)")
    } else if let address = address {
        print("Success: \(address)")
    }
}
```

**After (Async/Await):**
```swift
let client = ViacepClient()
do {
    let address = try await client.fetchAddress(cep: "01001000")
    print("Success: \(address)")
} catch {
    print("Error: \(error)")
}
```

**After (Completion Handler):**
```swift
let client = ViacepClient()
client.fetchAddress(cep: "01001000") { result in
    switch result {
    case .success(let address):
        print("Success: \(address)")
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

## Author

Regis Araujo Melo, regis@r3tecnologia.net

## License

viacep-ios is available under the MIT license. See the LICENSE file for more info.
