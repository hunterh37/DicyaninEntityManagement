import RealityKit
import DicyaninEntity

public class DicyaninEntityManager {
    // MARK: - Properties
    
    /// The root entity that contains all scenes
    private let rootEntity: Entity
    
    /// Currently loaded scene
    private(set) public var currentScene: DicyaninScene?
    
    /// Dictionary of loaded scenes
    private var loadedScenes: [String: DicyaninScene] = [:]
    
    // MARK: - Initialization
    
    public init() {
        self.rootEntity = Entity()
    }
    
    // MARK: - Scene Management
    
    /// Loads a scene configuration
    /// - Parameter scene: The scene configuration to load
    /// - Returns: Array of created entities
    @MainActor
    public func loadScene(_ scene: DicyaninScene) async throws -> [DicyaninEntity] {
        // Clear existing scene if any
        if let currentScene = currentScene {
            try await unloadScene(currentScene)
        }
        
        // Create and configure entities
        var entities: [DicyaninEntity] = []
        for config in scene.entityConfigurations {
            let entity = try await DicyaninEntity.create(from: config)
            rootEntity.addChild(entity)
            entities.append(entity)
        }
        
        // Store scene
        loadedScenes[scene.id] = scene
        currentScene = scene
        
        return entities
    }
    
    /// Unloads a scene and removes its entities
    /// - Parameter scene: The scene to unload
    @MainActor
    public func unloadScene(_ scene: DicyaninScene) async throws {
        guard let loadedScene = loadedScenes[scene.id] else { return }
        
        // Remove all entities from the scene
        for config in loadedScene.entityConfigurations {
            if let entity = rootEntity.children.first(where: { $0.name == config.name }) {
                entity.removeFromParent()
            }
        }
        
        // Clear scene data
        loadedScenes.removeValue(forKey: scene.id)
        if currentScene?.id == scene.id {
            currentScene = nil
        }
    }
    
    /// Returns the root entity that contains all scenes
    public func getRootEntity() -> Entity {
        return rootEntity
    }
    
    /// Returns all entities for a specific scene
    /// - Parameter sceneId: The ID of the scene
    /// - Returns: Array of DicyaninEntity objects for the scene
    public func getEntitiesForScene(_ sceneId: String) -> [DicyaninEntity]? {
        guard let scene = loadedScenes[sceneId] else { return nil }
        return rootEntity.children.compactMap { $0 as? DicyaninEntity }
    }
    
    /// Returns the total number of loaded scenes
    public var sceneCount: Int {
        return loadedScenes.count
    }
} 