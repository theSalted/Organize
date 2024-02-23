//
//  ScanSpaceTip.swift
//  Organize
//
//  Created by Yuhao Chen on 2/23/24.
//

import Foundation
import TipKit

struct ScanSpaceTip: Tip {
    var title = Text("Begin by Scanning Your Surrounding")
    var image = Image(systemName: "square.split.bottomrightquarter")
    var message = Text("Organize will scan your room and create a space and its storages for you.")
}
