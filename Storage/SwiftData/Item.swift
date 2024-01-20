//
//  Item.swift
//  Storage
//
//  Created by Yuhao Chen on 1/21/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var id : UUID
    var name : String
    var storage : Storage?
    
    init(name: String) {
        self.name = name
        self.id = UUID()
    }
    
    init(name: String, storage: Storage) {
        self.name = name
        self.id = UUID()
        self.storage = storage
    }
}

