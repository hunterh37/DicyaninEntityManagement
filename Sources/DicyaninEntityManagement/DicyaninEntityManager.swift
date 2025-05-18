import RealityKit
import DicyaninEntity

public class DicyaninEntityManager {
    // MARK: - Types
    
    /// Represents a single slide in the presentation
    public struct Slide {
        let id: Int
        let entities: [DicyaninEntity]
        var isVisible: Bool = false
    }
    
    // MARK: - Properties
    
    /// The current slide being displayed
    private(set) public var currentSlideId: Int?
    
    /// All slides in the presentation
    private var slides: [Int: Slide] = [:]
    
    /// The root entity that contains all slides
    private let rootEntity: Entity
    
    // MARK: - Initialization
    
    public init() {
        self.rootEntity = Entity()
    }
    
    // MARK: - Public Methods
    
    /// Adds a new slide to the presentation
    /// - Parameters:
    ///   - id: Unique identifier for the slide
    ///   - entities: Array of DicyaninEntity objects to show on this slide
    public func addSlide(id: Int, entities: [DicyaninEntity]) {
        // Hide all entities initially
        entities.forEach { $0.isEnabled = false }
        
        // Add entities to root
        entities.forEach { rootEntity.addChild($0) }
        
        // Store slide information
        slides[id] = Slide(id: id, entities: entities)
    }
    
    /// Shows a specific slide and hides all others
    /// - Parameter id: The ID of the slide to show
    public func showSlide(id: Int) {
        guard let slide = slides[id] else {
            print("Warning: Slide with ID \(id) not found")
            return
        }
        
        // Hide all slides
        slides.values.forEach { slide in
            slide.entities.forEach { $0.isEnabled = false }
        }
        
        // Show the requested slide
        slide.entities.forEach { $0.isEnabled = true }
        
        currentSlideId = id
    }
    
    /// Returns the root entity that contains all slides
    public func getRootEntity() -> Entity {
        return rootEntity
    }
    
    /// Removes a slide from the presentation
    /// - Parameter id: The ID of the slide to remove
    public func removeSlide(id: Int) {
        guard let slide = slides[id] else { return }
        
        // Remove entities from root
        slide.entities.forEach { $0.removeFromParent() }
        
        // Remove slide from storage
        slides.removeValue(forKey: id)
        
        // Update current slide if needed
        if currentSlideId == id {
            currentSlideId = nil
        }
    }
    
    /// Returns all entities for a specific slide
    /// - Parameter id: The ID of the slide
    /// - Returns: Array of DicyaninEntity objects for the slide
    public func getEntitiesForSlide(id: Int) -> [DicyaninEntity]? {
        return slides[id]?.entities
    }
    
    /// Returns the total number of slides
    public var slideCount: Int {
        return slides.count
    }
} 