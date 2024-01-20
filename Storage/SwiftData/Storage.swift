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
    @Relationship(deleteRule: .deny, inverse: \Item.storage)
    var items = [Item]()
    var space : Space?
    
    init(name: String? = "") {
        self.name = name
        self.id = UUID()
    }
}
