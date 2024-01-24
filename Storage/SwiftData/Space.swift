//
//  Item.swift
//  Storage
//
//  Created by Yuhao Chen on 1/21/24.
//

import Foundation
import SwiftData

@Model
final class Space : Identifiable, Meta {
    var id: UUID
    var name: String?
    var createdAt : Date?
    @Relationship(deleteRule: .cascade, inverse: \Storage.space)
    var storages = [Storage]()
    
    @Transient lazy var storedIn: String? = {
        nil
    }()
    
    init(name: String? = "Untitled") {
        self.name = name
        self.id = UUID()
        self.createdAt = Date()
    }
}
