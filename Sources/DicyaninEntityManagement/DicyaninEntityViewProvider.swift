import SwiftUI
import RealityKit
import DicyaninEntity

/// Protocol defining the requirements for a custom entity view provider
public protocol DicyaninEntityViewProvider {
    /// The scene configuration to be loaded
    var scene: DicyaninScene { get }
    
    /// Optional loading state handler
    var onLoadingStateChanged: ((Bool) -> Void)? { get }
    
    /// Optional error handler
    var onError: ((Error) -> Void)? { get }
    
    /// Optional entity loaded handler
    var onEntitiesLoaded: (([DicyaninEntity]) -> Void)? { get }
}

/// A default implementation of DicyaninEntityViewProvider
public struct DefaultDicyaninEntityViewProvider: DicyaninEntityViewProvider {
    public let scene: DicyaninScene
    public let onLoadingStateChanged: ((Bool) -> Void)?
    public let onError: ((Error) -> Void)?
    public let onEntitiesLoaded: (([DicyaninEntity]) -> Void)?
    
    public init(
        scene: DicyaninScene,
        onLoadingStateChanged: ((Bool) -> Void)? = nil,
        onError: ((Error) -> Void)? = nil,
        onEntitiesLoaded: (([DicyaninEntity]) -> Void)? = nil
    ) {
        self.scene = scene
        self.onLoadingStateChanged = onLoadingStateChanged
        self.onError = onError
        self.onEntitiesLoaded = onEntitiesLoaded
    }
}

/// A builder for creating scene configurations
public struct DicyaninSceneBuilder {
    private var id: String
    private var name: String
    private var description: String
    private var entityConfigurations: [DicyaninEntityConfiguration]
    
    public init(id: String, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
        self.entityConfigurations = []
    }
    
    public func addEntity(_ configuration: DicyaninEntityConfiguration) -> DicyaninSceneBuilder {
        var builder = self
        builder.entityConfigurations.append(configuration)
        return builder
    }
    
    public func addEntities(_ configurations: [DicyaninEntityConfiguration]) -> DicyaninSceneBuilder {
        var builder = self
        builder.entityConfigurations.append(contentsOf: configurations)
        return builder
    }
    
    public func build() -> DicyaninScene {
        DicyaninScene(
            id: id,
            name: name,
            description: description,
            entityConfigurations: entityConfigurations
        )
    }
} 