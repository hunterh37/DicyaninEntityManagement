import RealityKit
import DicyaninEntity

/// Represents a predefined scene configuration containing multiple entities
public struct DicyaninScene {
    /// Unique identifier for the scene
    public let id: String
    
    /// Name of the scene for display purposes
    public let name: String
    
    /// Description of the scene
    public let description: String
    
    /// Array of entity configurations that make up this scene
    public let entityConfigurations: [DicyaninEntityConfiguration]
    
    /// Creates a new scene configuration
    /// - Parameters:
    ///   - id: Unique identifier for the scene
    ///   - name: Display name for the scene
    ///   - description: Description of the scene
    ///   - entityConfigurations: Array of entity configurations
    public init(
        id: String,
        name: String,
        description: String,
        entityConfigurations: [DicyaninEntityConfiguration]
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.entityConfigurations = entityConfigurations
    }
} 