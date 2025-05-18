import SwiftUI
import RealityKit
import DicyaninEntity
import DicyaninEntityManagement

public struct DicyaninEntityView: View {
    @State private var entityManager: DicyaninEntityManager = DicyaninEntityManager()
    @State private var isLoading = true
    @State private var error: Error?
    
    private let provider: DicyaninEntityViewProvider
    
    public init(provider: DicyaninEntityViewProvider = DefaultDicyaninEntityViewProvider(
        scene: DicyaninScene(
            id: "demo_scene",
            name: "Demo Scene",
            description: "Demo scene description",
            entityConfigurations: [
                DicyaninEntityConfiguration(
                    name: "Flower",
                    position: SIMD3<Float>(0, 0, -1),
                    scale: SIMD3<Float>(repeating: 1)
                ),
                DicyaninEntityConfiguration(
                    name: "Camera",
                    position: SIMD3<Float>(1, 0, -1),
                    scale: SIMD3<Float>(repeating: 1)
                ),
            ]
        )
    )) {
        self.provider = provider
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
            provider.onEntitiesLoaded?(entities)
            provider.onLoadingStateChanged?(false)
        } catch {
            self.error = error
            provider.onError?(error)
            provider.onLoadingStateChanged?(false)
        }
    }
} 
