//
//  Item.swift
//  Storage
//
//  Created by Yuhao Chen on 1/21/24.
//

import Foundation
import SwiftData

@Model
final class Space : Identifiable {
    var id: UUID
    var name: String?
    
    @Relationship(deleteRule: .deny, inverse: \Storage.space)
    var storages = [Storage]()
    
    init(name: String? = "Untitled") {
        self.name = name
        self.id = UUID()
    }
}
