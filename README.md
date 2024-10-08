# GoodExtensions-iOS

[![iOS Version](https://img.shields.io/badge/iOS_Version->=_13.0-brightgreen?logo=apple&logoColor=green)]()
[![Swift Version](https://img.shields.io/badge/Swift_Version-6.0-green?logo=swift)](https://docs.swift.org/swift-book/)
[![Contains Test](https://img.shields.io/badge/Tests-YES-blue)]()
[![Dependency Manager](https://img.shields.io/badge/Dependency_Manager-SPM-red)](#swiftpackagemanager)

Good Extensions is a collection of useful and frequently used Swift extensions for iOS development. 
These extensions aim to simplify and streamline common tasks, making it easier for developers 
to write clean and concise code.

## Instalation

### Swift Package Manager

Create a `Package.swift` file and add the package dependency into the dependencies list.
Or to integrate without package.swift add it through the Xcode add package interface.

[//]: # (Don't forget to add the version once available)
```swift

import PackageDescription

let package = Package(
    name: "SampleProject",
    dependencies: [
        .package(url: "https://github.com/GoodRequest/GoodExtensions-iOS", .upToNextMajor("2.0.0")
    ]
)

```

## License
GoodExtensions is released under the MIT license. See [LICENSE](LICENSE.md) for details.
