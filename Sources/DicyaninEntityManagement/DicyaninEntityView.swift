import SwiftUI
import RealityKit
import DicyaninEntity
import DicyaninEntityManagement

public struct DicyaninEntityView: View {
    @State private var entityManager: DicyaninEntityManager?
    @State private var isLoading = true
    @State private var error: Error?
    
    public init() {}
    
    public var body: some View {
        RealityView { content in
            // Add the root entity to the RealityView
            if let rootEntity = entityManager?.getRootEntity() {
                content.add(rootEntity)
            }
        }
        .task {
            await loadScene()
        }
    }
    
    private func loadScene() async {
        do {
            // Create a demo scene
            let scene = DicyaninScene(
                id: "demo_scene",
                name: "Demo Scene",
                description: "A demonstration scene with bouncing and spinning entities",
                entityConfigurations: [
                    // A bouncing cube
                    DicyaninEntityConfiguration(
                        name: "bouncing_cube",
                        position: SIMD3<Float>(0, 0, -1),
                        scale: SIMD3<Float>(repeating: 0.3),
                        animation: ModelAnimation(type: .bounce(height: 0.5, duration: 1.0))
                    ),
                    // A spinning sphere
                    DicyaninEntityConfiguration(
                        name: "spinning_sphere",
                        position: SIMD3<Float>(1, 0, -1),
                        scale: SIMD3<Float>(repeating: 0.3),
                        animation: ModelAnimation(type: .spin(speed: 2.0, axis: SIMD3<Float>(0, 1, 0)))
                    ),
                    // A physics-enabled box
                    DicyaninEntityConfiguration(
                        name: "physics_box",
                        position: SIMD3<Float>(-1, 1, -1),
                        scale: SIMD3<Float>(repeating: 0.3),
                        physics: ModelPhysics(mass: 1.0, isDynamic: true),
                        collision: ModelCollision(shape: .box(size: SIMD3<Float>(repeating: 0.3)), isStatic: false)
                    )
                ]
            )
            
            // Create and load the scene
            let manager = DicyaninEntityManager()
            _ = try await manager.loadScene(scene)
            
            // Update state
            self.entityManager = manager
            self.isLoading = false
        } catch {
            self.error = error
            self.isLoading = false
        }
    }
} 
