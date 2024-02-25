//
//  CapturedRoom+Equatable.swift
//  Organize
//
//  Created by Yuhao Chen on 2/19/24.
//

import Foundation
import RoomPlan
import OSLog

// TODO: May need a better way, this is extremely sketchy way in so many ways. I implement equitable here to solve a very specific problem of matching two Rooms that have extremely similar coordinates. But extremely similar coordinator of all objects shouldn't mean the CapturedRooms are equal. And other properties is also not consider here.
extension CapturedRoom: Equatable {
    public static func == (lhs: CapturedRoom, rhs: CapturedRoom) -> Bool {
        logger.warning("Equatable implementation for CaptureRoom is very flawed at this moment because it only compare objects of two CapturedRooms without taking account of other properties. And Object's implementation is also flawed")
        return lhs.objects == rhs.objects
    }
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "CapturedRoom+Equatable")
