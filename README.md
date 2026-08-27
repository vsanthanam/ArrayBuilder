# ArrayBuilder

[![MIT License](https://img.shields.io/github/license/vsanthanam/ArrayBuilder)](https://github.com/vsanthanam/ArrayBuilder/blob/main/LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/vsanthanam/ArrayBuilder?include_prereleases)](https://github.com/vsanthanam/ArrayBuilder/releases)
[![Build Status](https://img.shields.io/github/check-runs/vsanthanam/ArrayBuilder/main)](https://github.com/vsanthanam/ArrayBuilder/actions)
[![Swift Version](https://img.shields.io/badge/swift-6.3-critical)](https://swift.org)
[![Xcode](https://img.shields.io/badge/xcode-26.5-blue)](https://developer.apple.com/xcode/)
[![Documentation](https://img.shields.io/badge/Documentation-Swift%20Package%20Index-8A2BE2)](https://swiftpackageindex.com/vsanthanam/ArrayBuilder/documentation)

A declarative library for composing arrays in Swift

## Overview

ArrayBuilder is SwiftUI for arrays. It provides a generic result builder, `ArrayBuilder<T>`, that lets you build an array the way you build a view hierarchy with `@ViewBuilder` — one element per line, with `if`, `else`, `switch`, and `for` statements mixed right in.

Build an array with the included `Array` initializer:

```swift
let numbers = Array {
    if includeZero {
        0
    }
    1
    [2, 3]
    for value in 4 ... 6 {
        value
    }
}
// [0, 1, 2, 3, 4, 5, 6] if includeZero is true
```

Or apply the builder to a function, a computed property, or a closure parameter in your own API:

```swift
@ArrayBuilder<String>
var groceries: [String] {
    "Milk"
    "Eggs"
    "Bread"
}
```

ArrayBuilder's declarative approach offers significant advantages over traditional imperative array construction.

Building command line arguments, without ArrayBuilder:

```swift
func arguments(verbose: Bool, files: [String]) -> [String] {
    var arguments = ["build"]
    if verbose {
        arguments.append("--verbose")
    }
    for file in files {
        arguments.append("--file")
        arguments.append(file)
    }
    return arguments
}
```

With ArrayBuilder:

```swift
@ArrayBuilder<String>
func arguments(verbose: Bool, files: [String]) -> [String] {
    "build"
    if verbose {
        "--verbose"
    }
    for file in files {
        "--file"
        file
    }
}
```

The declarative approach more closely resembles the final shape of the array, making it easier to read, maintain, and modify. It eliminates the mutable state, `append(_:)` calls, and explicit `return` that imperative construction requires, especially when the array depends on conditions, loops, or a mix of single values and other collections.

## Installation

ArrayBuilder is currently distributed exclusively through the [Swift Package Manager](https://www.swift.org/package-manager/).

To add ArrayBuilder as a dependency to an existing Swift package, add the following line of code to the `dependencies` parameter of your `Package.swift` file:

```swift
dependencies: [
    .package(
        url: "https://github.com/vsanthanam/ArrayBuilder.git",
        from: "1.0.0"
    )
]
```

To add ArrayBuilder as a dependency to an Xcode Project:

- Choose `File` → `Add Packages...`
- Enter package URL `https://github.com/vsanthanam/ArrayBuilder.git` and select your release of choice.

Other distribution mechanisms like CocoaPods or Carthage may be added in the future.

## Usage & Documentation

ArrayBuilder's documentation is built with [DocC](https://developer.apple.com/documentation/docc) and included in the repository.

Additional installation instructions are available on the [Swift Package Index](https://swiftpackageindex.com/vsanthanam/ArrayBuilder)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fvsanthanam%2FArrayBuilder%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/vsanthanam/ArrayBuilder)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fvsanthanam%2FArrayBuilder%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/vsanthanam/ArrayBuilder)

Explore [the documentation](https://swiftpackageindex.com/vsanthanam/ArrayBuilder/documentation) for more details.

## License

**ArrayBuilder** is available under the [MIT license](https://en.wikipedia.org/wiki/MIT_License). See the [LICENSE](https://github.com/vsanthanam/ArrayBuilder/blob/main/LICENSE) file for more information.
