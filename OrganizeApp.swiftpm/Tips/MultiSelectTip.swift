//
//  MultiSelectTip.swift
//  Organize
//
//  Created by Yuhao Chen on 2/23/24.
//

import Foundation
import TipKit

struct MultiSelectTip: Tip {
    var title: Text {
        Text("View Everything at Once")
    }
    var message: Text? {
        Text("Select multiple spaces, storages, and items at once to view them in a grid.")
    }
    var image: Image? {
        Image(systemName: "checklist.unchecked")
    }
}
