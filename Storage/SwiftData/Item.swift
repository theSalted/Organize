//
//  Item.swift
//  Storage
//
//  Created by Yuhao Chen on 1/21/24.
//

import Foundation
import SwiftData

@Model
final class Item : Identifiable {
    var id : UUID
    var name : String?
    var createdAt: Date?
    var storage : Storage?
    
    init(name: String) {
        self.name = name
        self.createdAt = Date.now
        self.id = UUID()
    }
    
    init(name: String? = "Untitled", storage: Storage) {
        self.name = name
        self.createdAt = Date.now
        self.id = UUID()
        self.storage = storage
    }
    
    static var randomSystemSymbol : String {
        get {
            ["soccerball", "lamp.desk.fill", "medal.fill", "gym.bag.fill", "skateboard.fill", "tennisball.fill", "tennis.racket", "basketball.fill", "gamecontroller.fill"].randomElement() ?? "soccerball"
        }
    }
}

