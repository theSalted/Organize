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
    
    @Transient var color : Color {
        get { _colorComponents.color }
        set { _colorComponents = ColorComponents.fromColor(newValue) }
    }
    
    @Transient lazy var storedIn: String? = {
        nil
    }()
    
    init(name: String = "Untitled") {
        self.name = name
        self.id = UUID()
        self.createdAt = Date()
        self.pattern = PatternDesign.getRandomDesign()
        self._colorComponents = ColorComponents.fromColor(templateColors.randomElement(or: .accent))
    }
}
