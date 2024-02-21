//
//  CapturedRoom.Object.Category+getName.swift
//  Organize
//
//  Created by Yuhao Chen on 2/22/24.
//

import RoomPlan

extension CapturedRoom.Object.Category {
    func getName() -> String {
        switch self {
        case .storage:
            return "Storage"
        case .refrigerator:
            return "Refrigerator"
        case .stove:
            return "Stove"
        case .bed:
            return "Bed"
        case .sink:
            return "Sink"
        case .washerDryer:
            return "Dryer/Washer"
        case .toilet:
            return "Toilet"
        case .bathtub:
            return "Bathtub"
        case .oven:
            return "Oven"
        case .dishwasher:
            return "Dishwasher"
        case .table:
            return "Table"
        case .sofa:
            return "Sofa"
        case .chair:
            return "Chair"
        case .fireplace:
            return "Fire Place"
        case .television:
            return "Television"
        case .stairs:
            return "Stairs"
        @unknown default:
            return "Unknown Space"
        }
    }
}
