//
//  Storage.swift
//  Storage
//
//  Created by Yuhao Chen on 1/21/24.
//

import Foundation
import SwiftData

@Model
final class Storage {
    var name : String?
    var id : UUID
    var createdAt: Date?
    @Relationship(deleteRule: .deny, inverse: \Item.storage)
    var items = [Item]()
    var space : Space?
    
    init(name: String? = "Untitled") {
        self.name = name
        self.createdAt = Date()
        self.id = UUID()
    }
}
