//
//  ObjectCaptureDataModel+State.swift
//  Organize
//
//  Created by Yuhao Chen on 2/3/24.
//

import Foundation

extension ObjectCaptureDataModel {
    enum ModelState: String, CustomStringConvertible {
        var description: String { rawValue }
        
        case notSet
        case ready
        case capturing
        case prepareToReconstruct
        case reconstructing
        case viewing
        case completed
        //        case pause
        //        case resume
        case restart
        case failed
    }
}
