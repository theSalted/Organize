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
class Item : Identifiable, Meta {
    var id: UUID
    var name: String
    var createdAt: Date
    var storage: Storage?
    var pattern: PatternDesign 
    @Relationship(deleteRule: .cascade, inverse: \CapturedObject.item)
    var capture: CapturedObject?
    
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

