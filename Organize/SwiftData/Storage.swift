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
    var name : String
    var id : UUID
    var createdAt: Date
    var systemImage: String?
    var pattern: PatternDesign
    @Relationship(deleteRule: .cascade, inverse: \Item.storage)
    var items = [Item]()
    var space : Space?
    private var _colorComponents : ColorComponents
    
    @Transient var color : Color {
        get { _colorComponents.color }
        set { _colorComponents = ColorComponents.fromColor(newValue) }
    }
    
    @Transient lazy var storedIn: String? = {
        space?.name
    }()
    
    init(name: String = "Untitled", systemImage: String = "archivebox") {
        self.name = name
        self.createdAt = Date()
        self.id = UUID()
        self.pattern = PatternDesign.getRandomDesign()
        self._colorComponents = ColorComponents.fromColor(templateColors.randomElement(or: .accent))
        self.systemImage = systemImage
    }
}