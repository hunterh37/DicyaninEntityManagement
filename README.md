# DicyaninEntityManagement

A Swift package for managing DicyaninEntity states in a slideshow-like manner, designed specifically for visionOS applications.

## Requirements

- visionOS 1.0+
- Swift 5.9+
- Xcode 15.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/DicyaninEntityManagement.git", from: "1.0.0")
]
```

## Usage

```swift
import DicyaninEntityManagement
import RealityKit

// Create a manager instance
let manager = DicyaninEntityManager()

// Define your slides and their associated entities
manager.addSlide(id: 1, entities: [entity1, entity2])
manager.addSlide(id: 2, entities: [entity3, entity4])

// Navigate between slides
manager.showSlide(id: 1)
```

## Features

- Slideshow-like state management for DicyaninEntity objects
- Smooth transitions between states
- Entity visibility control per slide
- Easy integration with visionOS applications

## License

This project is licensed under the MIT License - see the LICENSE file for details. 