//
//  CapturedRoom.Object+Equatable.swift
//  Organize
//
//  Created by Yuhao Chen on 2/19/24.
//

import Foundation
import RoomPlan
import OSLog

// TODO: May need a better way, this is extremely sketchy way in so many ways. I implement equitable here to solve a very specific problem of matching two Rooms that have extremely similar coordinates. But extremely similar coordinator of all objects shouldn't mean the CapturedRooms are equal. And other properties is also not consider here.
extension CapturedRoom.Object: Equatable {
    @available(*, deprecated, message: "This is a very flawed implementation of equatable")
    public static func == (lhs: CapturedRoom.Object, rhs: CapturedRoom.Object) -> Bool {
        logger.warning("Equatable implementation for CaptureRoom.object is very flawed at this moment, and is implemented to address a very specific problem of matching two CapturedRoom.Object with same identifier, transform, and dimension.")
        return lhs.identifier == rhs.identifier &&
               lhs.transform  == rhs.transform  &&
               lhs.dimensions == rhs.dimensions
    }
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "CapturedRoom.Object+Equatable")
