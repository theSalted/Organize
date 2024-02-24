//
//  MinimumCaptureTip.swift
//  Organize
//
//  Created by Yuhao Chen on 2/25/24.
//

import Foundation
import TipKit

struct MinimumCaptureTip: Tip {
    var title: Text {
        Text("10 pictures are the minimum requirements")
    }
    
    var image: Image? {
        Image(systemName: "photo.stack")
    }
    
    var message: Text? {
        Text("... for quick capture. Capture as much as possible for best result.")
    }
}
