//
//  Meta.swift
//  Organize
//
//  Created by Yuhao Chen on 1/24/24.
//

import Foundation
import SwiftUI

protocol Meta : Identifiable, Hashable, AnyObject where ID == UUID {
    var id:             UUID            { get set }
    var name:           String          { get set }
    var createdAt:      Date            { get set }
    var pattern:        PatternDesign   { get set }
    var color:          Color           { get set }
    var symbol:         String          { get set }
    var storedIn:       String?         { get }
    var image:          UIImage?          { get set }
}
