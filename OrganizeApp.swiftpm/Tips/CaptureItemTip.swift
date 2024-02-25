//
//  CaptureItemTip.swift
//  Organize
//
//  Created by Yuhao Chen on 2/23/24.
//

import Foundation
import TipKit

struct CaptureItemTip: Tip {
    var title: Text {
        Text("Capture an Item")
    }
    var message: Text? {
        Text("Capture a 3D model of your item and store it in a storage")
    }
    var image: Image? {
        Image(systemName: "cube")
    }
    var actions: [Action] {
        Action(id: "capture-item", title: "Capture")
    }
}
