//
//  Storage.swift
//  Organize
//
//  Created by Yuhao Chen on 1/21/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Storage : Identifiable, Meta {
    var name: String
    var id: UUID
    var createdAt: Date
    var pattern: PatternDesign
    
    @Relationship(deleteRule: .cascade, inverse: \Item.storage)
    var items = [Item]()
    
    var space: Space?
     
    private var _colorComponents: ColorComponents
    private var systemImage: String?
    private var emoji: String?
    
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
    
    var symbol: String {
        get {
            if let systemImage {
                return systemImage
            } else if let emoji {
                return emoji
            } else {
                systemImage = "archivebox"
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
    
    @Transient var color : Color {
        get { _colorComponents.color }
        set { _colorComponents = ColorComponents.fromColor(newValue) }
    }
    
    @Transient lazy var storedIn: String? = {
        space?.name
    }()
    
    init(name: String = "Untitled", symbol: String = "archivebox") {
        self.name = name
        self.createdAt = Date()
        self.id = UUID()
        self.pattern = PatternDesign.getRandomDesign()
        self._colorComponents = ColorComponents.fromColor(templateColors.randomElement(or: .accentColor))
        self.symbol = symbol
    }
}
