//
//  Item.swift
//  Organize
//
//  Created by Yuhao Chen on 1/21/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Space : Identifiable, Meta {
    var id: UUID
    var name: String
    var createdAt : Date
    var pattern: PatternDesign
    @Relationship(deleteRule: .cascade, inverse: \Storage.space)
    var storages = [Storage]()
    private var _colorComponents : ColorComponents
    
    private var systemImage: String?
    private var emoji: String?
    
    var symbol: String {
        get {
            if let systemImage {
                return systemImage
            } else if let emoji {
                return emoji
            } else {
                systemImage = "square.split.bottomrightquarter"
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
        nil
    }()
    
    init(name: String = "Untitled", symbol : String = "square.split.bottomrightquarter") {
        self.name = name
        self.id = UUID()
        self.createdAt = Date()
        self.pattern = PatternDesign.getRandomDesign()
        self._colorComponents = ColorComponents.fromColor(templateColors.randomElement(or: .accent))
        self.symbol = symbol
    }
}
