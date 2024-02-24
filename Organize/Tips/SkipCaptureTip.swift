//
//  SkipCaptureTip.swift
//  Organize
//
//  Created by Yuhao Chen on 2/25/24.
//

import Foundation
import TipKit

struct SkipCaptureTip: Tip {
    var title: Text {
        Text("Press `skip` button for quick capture")
    }
    
    var image: Image? {
        Image(systemName: "arrowshape.right.fill")
    }
    
    var message: Text? {
        Text("Then press `skip` again and `finish` button. Result may be subpar.")
    }
}
