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
    var systemImage: String?
    var pattern: PatternDesign
    
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
    
    init(name: String = "Untitled", systemImage: String = "cube", storage: Storage) {
        self.name = name
        self.createdAt = Date.now
        self.id = UUID()
        self.storage = storage
        self.pattern = PatternDesign.getRandomDesign()
        self._colorComponents = ColorComponents.fromColor(templateColors.randomElement(or: .accent))
        self.systemImage = systemImage
    }
    
    static var randomSystemSymbol: String {
        get {
            ["soccerball",
             "lamp.desk.fill",
             "medal.fill",
             "gym.bag.fill",
             "skateboard.fill",
             "tennisball.fill",
             "tennis.racket",
             "basketball.fill",
             "gamecontroller.fill"
            ].randomElement() ?? "soccerball"
        }
    }
}