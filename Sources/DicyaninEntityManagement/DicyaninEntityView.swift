import SwiftUI
import RealityKit
import DicyaninEntity
import DicyaninEntityManagement

public struct DicyaninEntityView: View {
    @State private var entityManager: DicyaninEntityManager = DicyaninEntityManager()
    @State private var isLoading = true
    @State private var error: Error?
    
    public init() {}
    
    public var body: some View {
        RealityView { content in
            // Add the root entity to the RealityView
            content.add(entityManager.rootEntity)
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
                description: "Demo scene description",
                entityConfigurations: [
                    // A bouncing cube
                    DicyaninEntityConfiguration(
                        name: "Flower",
                        position: SIMD3<Float>(0, 0, -1),
                        scale: SIMD3<Float>(repeating: 1)
                    ),
                    // A spinning sphere
                    DicyaninEntityConfiguration(
                        name: "Camera",
                        position: SIMD3<Float>(1, 0, -1),
                        scale: SIMD3<Float>(repeating: 1)
                    ),
                ]
            )
            
            // Create and load the scene
            _ = try await entityManager.loadScene(scene)
            
            self.isLoading = false
        } catch {
            self.error = error
            self.isLoading = false
        }
    }
} 
