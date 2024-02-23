//
//  ScanSpaceTip.swift
//  Organize
//
//  Created by Yuhao Chen on 2/23/24.
//

import Foundation
import TipKit

struct ScanSpaceTip: Tip {
    var title: Text {
        Text("Begin by Scanning Your Surrounding")
    }
    var message: Text? {
        Text("Organize will scan your room and create a space and its storages for you.")
    }
    var image: Image? {
        Image(systemName: "square.split.bottomrightquarter")
    }
    var actions: [Action] {
        // Define a reset password button.
        Action(id: "scan-space", title: "Scan Surrounding")
    }
}
