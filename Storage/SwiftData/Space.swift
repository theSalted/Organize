//
//  Item.swift
//  Storage
//
//  Created by Yuhao Chen on 1/21/24.
//

import Foundation
import SwiftData

@Model
final class Space  {
    var id: UUID
    var name: String?
//    var items = [Item]()
    @Relationship(deleteRule: .deny, inverse: \Storage.space)
    var storages = [Storage]()
    
    init(name: String? = "") {
        self.name = name
        self.id = UUID()
    }
}
