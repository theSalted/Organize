//
//  Item.swift
//  Organize
//
//  Created by Yuhao Chen on 1/21/24.
//

import Foundation
import SwiftData
import SwiftUI
import Vision
import OSLog
import VideoToolbox

@Model
final class Item : Identifiable, Meta {
    var id: UUID
    var name: String
    var createdAt: Date
    var storage: Storage?
    var pattern: PatternDesign 
    
    @Relationship(deleteRule: .cascade, inverse: \CapturedObject.item)
    var capture: CapturedObject?
    
    @Attribute(.externalStorage) var imageData: Data?
    
    @Transient var image: UIImage? {
        get {
            if let data = imageData,
               let uiImage = UIImage(data: data) {
                return uiImage
            }
            return nil
        }
        set {
            imageData = newValue?.pngData()
        }
    }
    
    @Transient var subjectMaskedImage: UIImage? {
        get {
            let request = VNGenerateForegroundInstanceMaskRequest()
            guard let cgImage = image?.cgImage else {
                logger.warning("Couldn't generate cgImage from uiImage")
                return nil
            }
            let handler = VNImageRequestHandler(cgImage: cgImage)
            try? handler.perform([request])
            guard let result = request.results?.first else {
                logger.warning("VNImageRequestHandler did not return result from performing VNGenerateForegroundInstanceMaskRequest")
                return nil
            }
            guard let output = try? result.generateMaskedImage(
                ofInstances: result.allInstances,
                from: handler, 
                croppedToInstancesExtent: true)
            else {
                logger.warning("Couldn't generateMaskedImage from result of VNGenerateForegroundInstanceMaskRequest")
                return nil
            }
            var outputCGImage: CGImage?
            VTCreateCGImageFromCVPixelBuffer(output, options: nil, imageOut: &outputCGImage)
            guard let outputCGImage else {
                logger.warning("Failed to create a cgimage from pixel buffer")
                return nil
            }
            return UIImage(cgImage: outputCGImage)
        }
    }
    
    private var systemImage: String?
    private var emoji: String?
    
    var symbol: String {
        get {
            if let systemImage {
                return systemImage
            } else if let emoji {
                return emoji
            } else {
                systemImage = "cube.fill"
                return systemImage!
            }
        }
        set {
            if newValue.isSingleEmoji {
                systemImage = nil
                emoji = newValue
            } else {
                emoji = nil 
                systemImage = newValue
            }
        }
    }
    
    private var _colorComponents : ColorComponents
    
    @Attribute(.externalStorage) private var squareThumbnailData: Data?
    @Attribute(.externalStorage) private var rectangleThumbnailData: Data?
    
    @Transient var color : Color {
        get { _colorComponents.color }
        set { _colorComponents = ColorComponents.fromColor(newValue) }
    }
    
    @Transient lazy var storedIn: String? = {
        storage?.name
    }()
    
    init(name: String) {
        self.name = name
        self.createdAt = Date.now
        self.id = UUID()
        self.pattern = PatternDesign.getRandomDesign()
        self._colorComponents = ColorComponents.fromColor(templateColors.randomElement(or: .accent))
    }
    
    init(name: String = "Untitled", symbol: String = "cube.fill") {
        self.name = name
        self.createdAt = Date.now
        self.id = UUID()
        self.pattern = PatternDesign.getRandomDesign()
        self._colorComponents = ColorComponents.fromColor(templateColors.randomElement(or: .accent))
        self.symbol = symbol
    }
    
    static var symbolList: [String] = [
        "cube.fill",
        "soccerball",
        "lamp.desk.fill",
        "medal.fill",
        "gym.bag.fill",
        "skateboard.fill",
        "tennisball.fill",
        "tennis.racket",
        "basketball.fill",
        "gamecontroller.fill"]
    
    static var randomSystemSymbol: String {
        get {
            symbolList.randomElement() ?? "cube.fill"
        }
    }
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "Item")
