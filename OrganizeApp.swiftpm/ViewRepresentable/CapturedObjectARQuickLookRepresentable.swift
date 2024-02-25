//
//  ObjectCaptureARQuickLookController.swift
//  Organize
//
//  Created by Yuhao Chen on 2/4/24.
//

import OSLog
import Foundation
import QuickLook
import ARKit
import SwiftUI

struct CapturedObjectARQuickLookRepresentable: UIViewControllerRepresentable {
    static let logger = Logger(subsystem: OrganizeApp.bundleId,
                                category: "ARQuickLookController")

    let modelFile: URL
    let endCaptureCallback: () -> Void

    func makeUIViewController(context: Context) -> QuickLookViewController {
        let controller = QuickLookViewController()
        controller.qlvc.dataSource = context.coordinator
        controller.qlvc.delegate = context.coordinator
        return controller
    }

    func makeCoordinator() -> CapturedObjectARQuickLookRepresentable.Coordinator {
        return Coordinator(parent: self)
    }

    func updateUIViewController(_ uiViewController: QuickLookViewController, context: Context) {}

    class Coordinator: NSObject, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
        let parent: CapturedObjectARQuickLookRepresentable

        init(parent: CapturedObjectARQuickLookRepresentable) {
            self.parent = parent
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.modelFile as QLPreviewItem
        }

        func previewControllerWillDismiss(_ controller: QLPreviewController) {
            CapturedObjectARQuickLookRepresentable.logger.log("Exiting ARQL ...")
            parent.endCaptureCallback()
        }
    }
}
