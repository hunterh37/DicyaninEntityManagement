# DicyaninEntityManagement

A Swift package for managing 3D entities and scenes in RealityKit applications.

## Features

- Scene management with entity configurations
- Support for animations, physics, and interactions
- Easy integration with RealityKit and SwiftUI
- Thread-safe entity management
- Memory-efficient resource handling

## Quick Example

```swift
import SwiftUI
import RealityKit
import DicyaninEntityManagement

struct MySceneView: View {
    var body: some View {
        // Simple usage with default scene and default entity
        DicyaninEntityView()
        
        // Use default entity configuration with custom scene details
        DicyaninEntityView(
            sceneId: "my_scene",
            sceneName: "My First Scene",
            sceneDescription: "A simple scene with default entity"
        )
        
        // Use custom entity configuration
        DicyaninEntityView(
            sceneId: "custom_scene",
            sceneName: "Custom Scene",
            sceneDescription: "A scene with custom entities",
            entityConfigurations: [
                DicyaninEntityConfiguration(
                    name: "spinning_cube",
                    position: SIMD3<Float>(0, 0, -1),
                    scale: SIMD3<Float>(repeating: 0.3),
                    animation: ModelAnimation(type: .spin(speed: 2.0, axis: SIMD3<Float>(0, 1, 0)))
                )
            ]
        )
        
        // Use default entity configuration with custom handlers
        DicyaninEntityView(
            onLoadingStateChanged: { isLoading in
                print("Loading state: \(isLoading)")
            },
            onError: { error in
                print("Error occurred: \(error)")
            },
            onEntitiesLoaded: { entities in
                print("Loaded \(entities.count) entities")
            }
        )
    }
}

## Installation

Add the package to your Xcode project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/hunterh37/DicyaninEntityManagement.git", from: "1.0.0"),
    .package(url: "https://github.com/hunterh37/DicyaninEntity.git", from: "1.0.0")  // Required dependency
]
```

> **Note**: This package requires `DicyaninEntity` as a dependency. Make sure to include both packages in your project.

## API Documentation

### DicyaninEntityManager

The core class responsible for managing scenes and entities.

```swift
public class DicyaninEntityManager {
    /// The root entity that contains all scenes
    let rootEntity: Entity
    
    /// Currently loaded scene
    private(set) public var currentScene: DicyaninScene?
    
    /// Returns the total number of loaded scenes
    public var sceneCount: Int
    
    /// Loads a scene configuration
    /// - Parameter scene: The scene configuration to load
    /// - Returns: Array of created entities
    @MainActor
    public func loadScene(_ scene: DicyaninScene) async throws -> [DicyaninEntity]
    
    /// Unloads a scene and removes its entities
    /// - Parameter scene: The scene to unload
    @MainActor
    public func unloadScene(_ scene: DicyaninScene) async throws
    
    /// Returns all entities for a specific scene
    /// - Parameter sceneId: The ID of the scene
    /// - Returns: Array of DicyaninEntity objects for the scene
    public func getEntitiesForScene(_ sceneId: String) -> [DicyaninEntity]?
}
```

### DicyaninScene

Represents a scene configuration containing multiple entities.

```swift
public struct DicyaninScene {
    /// Unique identifier for the scene
    public let id: String
    
    /// Name of the scene for display purposes
    public let name: String
    
    /// Description of the scene
    public let description: String
    
    /// Array of entity configurations that make up this scene
    public let entityConfigurations: [DicyaninEntityConfiguration]
}
```

### DicyaninSceneBuilder

A builder for creating scene configurations with a fluent interface.

```swift
public struct DicyaninSceneBuilder {
    /// Creates a new scene builder
    /// - Parameters:
    ///   - id: Unique identifier for the scene
    ///   - name: Display name for the scene
    ///   - description: Description of the scene
    public init(id: String, name: String, description: String)
    
    /// Adds a single entity configuration to the scene
    /// - Parameter configuration: The entity configuration to add
    /// - Returns: The builder instance for method chaining
    public func addEntity(_ configuration: DicyaninEntityConfiguration) -> DicyaninSceneBuilder
    
    /// Adds multiple entity configurations to the scene
    /// - Parameter configurations: Array of entity configurations to add
    /// - Returns: The builder instance for method chaining
    public func addEntities(_ configurations: [DicyaninEntityConfiguration]) -> DicyaninSceneBuilder
    
    /// Builds the final scene configuration
    /// - Returns: A DicyaninScene instance
    public func build() -> DicyaninScene
}
```

### DicyaninEntityViewProvider

Protocol defining the requirements for a custom entity view provider.

```swift
public protocol DicyaninEntityViewProvider {
    /// The scene configuration to be loaded
    var scene: DicyaninScene { get }
    
    /// Optional loading state handler
    /// - Parameter isLoading: Boolean indicating if the scene is currently loading
    var onLoadingStateChanged: ((Bool) -> Void)? { get }
    
    /// Optional error handler
    /// - Parameter error: The error that occurred during scene loading
    var onError: ((Error) -> Void)? { get }
    
    /// Optional entity loaded handler
    /// - Parameter entities: Array of loaded entities
    var onEntitiesLoaded: (([DicyaninEntity]) -> Void)? { get }
}
```

### DefaultDicyaninEntityViewProvider

A default implementation of DicyaninEntityViewProvider.

```swift
public struct DefaultDicyaninEntityViewProvider: DicyaninEntityViewProvider {
    /// Creates a new default provider
    /// - Parameters:
    ///   - scene: The scene configuration to load
    ///   - onLoadingStateChanged: Optional loading state handler
    ///   - onError: Optional error handler
    ///   - onEntitiesLoaded: Optional entity loaded handler
    public init(
        scene: DicyaninScene,
        onLoadingStateChanged: ((Bool) -> Void)? = nil,
        onError: ((Error) -> Void)? = nil,
        onEntitiesLoaded: (([DicyaninEntity]) -> Void)? = nil
    )
}
```

### DicyaninEntityView

A SwiftUI view for displaying and managing 3D entities.

```swift
public struct DicyaninEntityView: View {
    /// Creates a new entity view
    /// - Parameter provider: The provider to use for scene configuration
    public init(provider: DicyaninEntityViewProvider = DefaultDicyaninEntityViewProvider(...))
}
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

You can use the default implementation:

```swift
import SwiftUI
import RealityKit
import DicyaninEntityManagement

struct ContentView: View {
    var body: some View {
        // Use default scene and entity
        DicyaninEntityView()
        
        // Or customize just the scene details
        DicyaninEntityView(
            sceneId: "custom_default",
            sceneName: "Custom Default",
            sceneDescription: "A customized default scene"
        )
        
        // Or use custom entities
        DicyaninEntityView(
            sceneId: "custom_entities",
            sceneName: "Custom Entities",
            sceneDescription: "A scene with custom entities",
            entityConfigurations: [
                DicyaninEntityConfiguration(
                    name: "custom_entity",
                    position: SIMD3<Float>(0, 0, -1),
                    scale: SIMD3<Float>(repeating: 0.5)
                )
            ]
        )
    }
}
```

Or create your own custom implementation with the builder pattern:

```swift
import SwiftUI
import RealityKit
import DicyaninEntityManagement

// Create a custom scene provider
struct MySceneProvider: DicyaninEntityViewProvider {
    let scene: DicyaninScene
    
    // Optional handlers for scene lifecycle events
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((Error) -> Void)?
    var onEntitiesLoaded: (([DicyaninEntity]) -> Void)?
    
    init(
        sceneId: String,
        sceneName: String,
        sceneDescription: String,
        entityConfigurations: [DicyaninEntityConfiguration],
        onLoadingStateChanged: ((Bool) -> Void)? = nil,
        onError: ((Error) -> Void)? = nil,
        onEntitiesLoaded: (([DicyaninEntity]) -> Void)? = nil
    ) {
        // Create scene using the builder pattern
        self.scene = DicyaninSceneBuilder(id: sceneId, name: sceneName, description: sceneDescription)
            .addEntities(entityConfigurations)
            .build()
        
        self.onLoadingStateChanged = onLoadingStateChanged
        self.onError = onError
        self.onEntitiesLoaded = onEntitiesLoaded
    }
}

// Example usage in a view
struct CustomContentView: View {
    private let entityConfigurations: [DicyaninEntityConfiguration] = [
        DicyaninEntityConfiguration(
            name: "custom_entity_1",
            position: SIMD3<Float>(0, 0, -1),
            scale: SIMD3<Float>(repeating: 0.5)
        ),
        DicyaninEntityConfiguration(
            name: "custom_entity_2",
            position: SIMD3<Float>(1, 0, -1),
            scale: SIMD3<Float>(repeating: 0.5)
        )
    ]
    
    var body: some View {
        DicyaninEntityView(
            provider: MySceneProvider(
                sceneId: "custom_scene",
                sceneName: "My Custom Scene",
                sceneDescription: "A custom scene with multiple entities",
                entityConfigurations: entityConfigurations,
                onLoadingStateChanged: { isLoading in
                    print("Loading state: \(isLoading)")
                },
                onError: { error in
                    print("Error occurred: \(error)")
                },
                onEntitiesLoaded: { entities in
                    print("Loaded \(entities.count) entities")
                }
            )
        )
    }
}
```

You can also use the builder pattern directly with the default provider:

```swift
struct BuilderExampleView: View {
    var body: some View {
        let scene = DicyaninSceneBuilder(
            id: "builder_scene",
            name: "Builder Scene",
            description: "Scene created using the builder pattern"
        )
        .addEntity(DicyaninEntityConfiguration(
            name: "entity_1",
            position: SIMD3<Float>(0, 0, -1),
            scale: SIMD3<Float>(repeating: 0.5)
        ))
        .addEntity(DicyaninEntityConfiguration(
            name: "entity_2",
            position: SIMD3<Float>(1, 0, -1),
            scale: SIMD3<Float>(repeating: 0.5)
        ))
        .build()
        
        return DicyaninEntityView(
            provider: DefaultDicyaninEntityViewProvider(
                scene: scene,
                onLoadingStateChanged: { isLoading in
                    print("Loading state: \(isLoading)")
                },
                onError: { error in
                    print("Error occurred: \(error)")
                },
                onEntitiesLoaded: { entities in
                    print("Loaded \(entities.count) entities")
                }
            )
        )
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

- visionOS 1.0+
- Xcode 15.0+
- Swift 5.9+

## License

This project is licensed under the MIT License - see the LICENSE file for details. 