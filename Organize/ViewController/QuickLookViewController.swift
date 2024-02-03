//
//  QuickLookViewController.swift
//  Organize
//
//  Created by Yuhao Chen on 2/4/24.
//

import Foundation
import UIKit
import QuickLook

class QuickLookViewController: UIViewController {
    let qlvc = QLPreviewController()
    var qlPresented = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !qlPresented {
            present(qlvc, animated: false, completion: nil)
            qlPresented = true
        }
    }
}
