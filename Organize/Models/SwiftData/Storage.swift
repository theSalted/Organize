//
//  Storage.swift
//  Organize
//
//  Created by Yuhao Chen on 1/21/24.
//

import Foundation
import SwiftData

@Model
final class Storage : Identifiable, Meta {
    var name : String
    var id : UUID
    var createdAt: Date
    var pattern: PatternDesign
    @Relationship(deleteRule: .cascade, inverse: \Item.storage)
    var items = [Item]()
    var space : Space?
    @Transient lazy var storedIn: String? = {
        space?.name
    }()
    
    init(name: String = "Untitled") {
        self.name = name
        self.createdAt = Date()
        self.id = UUID()
        self.pattern = PatternDesign.getRandomDesign()
    }
}
