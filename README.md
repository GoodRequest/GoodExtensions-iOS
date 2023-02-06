# iOS-GoodExtensions

[![iOS Version](https://img.shields.io/badge/iOS_Version->=_12.0-brightgreen?logo=apple&logoColor=green)]()
[![Swift Version](https://img.shields.io/badge/Swift_Version-5.5-green?logo=swift)](https://docs.swift.org/swift-book/)
[![Supported devices](https://img.shields.io/badge/Supported_Devices-iPhone/iPad-green)]()
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
        .Package(url: "https://github.com/GoodRequest/iOS-GoodExtensions" from: "addVersion")
    ]
)

```

## Usage

### Then
Then is a useful way to set properties with closures just after initializing.

```swift
let myLabel = UILabel().then {
    $0.textAlignment = .center
    $0.textColor = .black
    $0.text = "Hello, World!"
}
```

### UIKit & Foundation Extensions
Use our extensions with `.gr` just like this:

```swift

myCollectionView.gr.registerCell(fromClass: MyCollectionViewCell.self)

myTableView.gr.registerHeaderFooterView(fromClass: MyTableViewHeader.self)

myarray.gr.hasItems
myArray.gr.removedDuplicates()

```
### UIKit Combine
You can define Publisher for your button or other user interactive elements

```swift

private(set) lazy var buttonPublisher = myButton.gr.publisher(for: .touchUpInside)

```
then subcribe to it and handle the actions whenever user interacts with the element

```swift

buttonPublisher
    .sink { [weak self] _ in
        // do actions
    }
    .store(in: &cancellables)
    
```

## License
GoodExtensions is released under the MIT license. See [LICENSE](LICENSE.md) for details.
