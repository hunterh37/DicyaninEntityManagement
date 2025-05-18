# DicyaninEntityManagement

A Swift package for managing 3D entities and scenes in RealityKit applications.

## Features

- Scene management with entity configurations
- Support for animations, physics, and interactions
- Easy integration with RealityKit and SwiftUI
- Thread-safe entity management
- Memory-efficient resource handling

## Installation

Add the package to your Xcode project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/DicyaninEntityManagement.git", from: "1.0.0")
]
```

## Usage

### Basic Scene Management

```swift
import DicyaninEntityManagement
import RealityKit

// Create a scene configuration
let scene = DicyaninScene(
    id: "my_scene",
    name: "My Scene",
    description: "A scene with multiple entities",
    entityConfigurations: [
        // A bouncing cube
        DicyaninEntityConfiguration(
            name: "bouncing_cube",
            position: SIMD3<Float>(0, 0, -1),
            scale: SIMD3<Float>(repeating: 0.3),
            animation: ModelAnimation(type: .bounce(height: 0.5, duration: 1.0))
        ),
        // A physics-enabled sphere
        DicyaninEntityConfiguration(
            name: "physics_sphere",
            position: SIMD3<Float>(1, 0, -1),
            scale: SIMD3<Float>(repeating: 0.3),
            physics: ModelPhysics(mass: 1.0, isDynamic: true),
            collision: ModelCollision(shape: .sphere(radius: 0.3), isStatic: false)
        )
    ]
)

// Create and load the scene
let entityManager = DicyaninEntityManager()
let entities = try await entityManager.loadScene(scene)

// Unload the scene when done
try await entityManager.unloadScene(scene)
```

### Using with SwiftUI

```swift
import SwiftUI
import RealityKit
import DicyaninEntityManagement

struct ContentView: View {
    var body: some View {
        DicyaninEntityView()
    }
}
```

### Entity Configuration

Entities can be configured with various properties:

```swift
let config = DicyaninEntityConfiguration(
    name: "my_entity",
    position: SIMD3<Float>(0, 0, -1),
    rotation: simd_quatf(angle: .pi/4, axis: SIMD3<Float>(0, 1, 0)),
    scale: SIMD3<Float>(repeating: 0.5),
    playAnimation: true,
    animation: ModelAnimation(type: .spin(speed: 2.0, axis: SIMD3<Float>(0, 1, 0))),
    physics: ModelPhysics(mass: 1.0, isDynamic: true),
    collision: ModelCollision(shape: .box(size: SIMD3<Float>(repeating: 0.5)), isStatic: false)
)
```

## Requirements

- iOS 15.0+ / macOS 12.0+
- Xcode 13.0+
- Swift 5.5+

## License

This project is licensed under the MIT License - see the LICENSE file for details. 