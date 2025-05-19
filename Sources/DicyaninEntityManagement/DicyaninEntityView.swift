import SwiftUI
import RealityKit
import DicyaninEntity
import DicyaninEntityManagement

public struct DicyaninEntityView: View {
    @State private var entityManager: DicyaninEntityManager = DicyaninEntityManager()
    @State private var isLoading = true
    @State private var error: Error?
    
    private let provider: DicyaninEntityViewProvider
    
    /// Default entity configurations for a basic scene
    public static let defaultEntityConfigurations: [DicyaninEntityConfiguration] = [
        DicyaninEntityConfiguration(
            name: "default_entity",
            position: SIMD3<Float>(0, 0, -1),
            scale: SIMD3<Float>(repeating: 0.5)
        )
    ]
    
    /// Creates a new entity view with a custom provider
    /// - Parameter provider: The provider to use for scene configuration
    public init(provider: DicyaninEntityViewProvider) {
        self.provider = provider
    }
    
    /// Creates a new entity view with a default scene
    /// - Parameters:
    ///   - sceneId: Unique identifier for the scene
    ///   - sceneName: Display name for the scene
    ///   - sceneDescription: Description of the scene
    ///   - entityConfigurations: Array of entity configurations (defaults to DicyaninEntityView.defaultEntityConfigurations)
    ///   - onLoadingStateChanged: Optional loading state handler
    ///   - onError: Optional error handler
    ///   - onEntitiesLoaded: Optional entity loaded handler
    ///   - onEntityLoaded: Optional handler for each individual entity as it's loaded
    public init(
        sceneId: String = "default_scene",
        sceneName: String = "Default Scene",
        sceneDescription: String = "A default scene with basic entities",
        entityConfigurations: [DicyaninEntityConfiguration] = defaultEntityConfigurations,
        onLoadingStateChanged: ((Bool) -> Void)? = nil,
        onError: ((Error) -> Void)? = nil,
        onEntitiesLoaded: (([DicyaninEntity]) -> Void)? = nil,
        onEntityLoaded: ((DicyaninEntity) -> Void)? = nil
    ) {
        let scene = DicyaninSceneBuilder(
            id: sceneId,
            name: sceneName,
            description: sceneDescription
        )
        .addEntities(entityConfigurations)
        .build()
        
        self.provider = DefaultDicyaninEntityViewProvider(
            scene: scene,
            onLoadingStateChanged: onLoadingStateChanged,
            onError: onError,
            onEntitiesLoaded: onEntitiesLoaded,
            onEntityLoaded: onEntityLoaded
        )
    }
    
    public var body: some View {
        RealityView { content in
            content.add(entityManager.rootEntity)
        }
        .task {
            await loadScene()
        }
    }
    
    private func loadScene() async {
        provider.onLoadingStateChanged?(true)
        do {
            let entities = try await entityManager.loadScene(provider.scene)
            
            // Call onEntityLoaded for each entity
            for entity in entities {
                provider.onEntityLoaded?(entity)
            }
            
            provider.onEntitiesLoaded?(entities)
            provider.onLoadingStateChanged?(false)
        } catch {
            self.error = error
            provider.onError?(error)
            provider.onLoadingStateChanged?(false)
        }
    }
} 
