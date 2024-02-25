import SwiftUI

struct TechnologiesView: View {
    @Environment(OnboardViewModel.self) private var onboardViewModel
    
    var body: some View {
        Form {
            VStack(spacing: 30) {
                Text("Technologies")
                    .font(.system(.largeTitle, weight: .bold))
                Text("Organize is enabled by powerful technologies available to iPadOS. Here are all 30 frameworks used:") 
                    .lineSpacing(10)
                    .multilineTextAlignment(.center)
            }
            .padding()
            List {
                Section("UI & App Frameworks") {
                    TechnologyItemView("SwiftUI", "UI/Application Framework")
                    TechnologyItemView("UIKit", "Adopt UIKit Only Frameworks to SwiftUI")
                    TechnologyItemView("Metal", "Pattern System and shader support")
                    TechnologyItemView("Observation", "MVVM and Composabale Architecture (but mostly ViewModels)")
                    TechnologyItemView("SwiftChart", "Data Visualiztion")
                    TechnologyItemView("TipKit", "Tips for You")
                }
                
                Section("Machine Learning") { 
                    TechnologyItemView("CoreML", "For ML Image Classification")
                }
                Section("Space/Room Scanning & Location") { 
                    TechnologyItemView("RoomPlan", "Space Scanning Framework")
                    TechnologyItemView("MapKit", "Map and Location Service Support")
                    TechnologyItemView("CoreLocation", "Location Processing and Conversion")
                }
                
                Section("Object Capture & Photogrammetry") { 
                    TechnologyItemView("RealityKit", "ObjectCapture, Photogrammetry and AR")
                    TechnologyItemView("QuickLookThumbnailing", "Generate Thumbnail for Captured Item")
                    TechnologyItemView("AVKit", "Video Player for Capture Instruction")
                }
                
                Section("Subject Lifting & Computer Vision") { 
                    TechnologyItemView("Vision", "Subject Liftng and Masking")
                    TechnologyItemView("VideoToolbox", "CGImage to UIImage conversion")
                }
                
                Section("AR Experience & Preview") { 
                    TechnologyItemView("ARKIt", "Provide Custom AR Experience and Preview for RoomPlan and ObjectCapture.")
                    TechnologyItemView("QuickLook", "AR Preview")
                }
                
                Section("USDZ Preview") { 
                    TechnologyItemView("SceneKit", "For Previewing USDZ in SwiftUI")
                    TechnologyItemView("SceneKit.ModelIO", "For Converting USDZ to SCNNode")
                }
                
                Section("2D Game Engine (Item Bucket)") { 
                    TechnologyItemView("SpriteKit", "Game Engine that Runs Item Bucket (Gamify)")
                    TechnologyItemView("GamePlayKit", "Entity Component System (mainly component) Support")
                    TechnologyItemView("Core Motion", "Real Gravity in Game")
                }
                
                Section("Camera Service") { 
                    TechnologyItemView("AVFoundation", "Custom Camera Implementation")
                    TechnologyItemView("PhotosUI", "SwiftUI Permission-less Photo Picker")
                }
                
                Section("Auxiliary Framework") { 
                    TechnologyItemView("Combine", "Bridging and Duct-tapping Frameworks")
                    TechnologyItemView("Dispatch", "Grand Central Dispatch, Queue, and Multiprocessing")
                    TechnologyItemView("UTType", "Documents Browser Support")
                    TechnologyItemView("Accelerate", "SIMD for Fast Matrix Transformation. 3D to 2D Projection")
                    TechnologyItemView("OS", "File System and Good Old Logging")
                }
            }
            
        }
        .contentMargins(.bottom, 100, for: .scrollContent)
        .overlay { 
            VStack {
                Spacer()
                Button("Continue") {
                    withAnimation {
                        onboardViewModel.stage = .tip
                    }
                }
                .buttonStyle(GlowingButtonStyle())
                .padding()
            }
        }
        .ignoresSafeArea()
    }
}


struct TechnologyItemView: View {
    var technology: String
    var description: String
    
    init(_ technology: String, _ description: String) {
        self.technology = technology
        self.description = description
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(technology).font(.headline)
            Text(description).font(.caption)
        }
        .padding(.horizontal)
    }
}
