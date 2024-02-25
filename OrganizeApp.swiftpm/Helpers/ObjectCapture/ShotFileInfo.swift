//
//  ShotFileInfo.swift
//  Organize
//
//  Created by Yuhao Chen on 2/3/24.
//

import Foundation

struct ShotFileInfo {
    let fileURL: URL
    let id: UInt32

    init?(url: URL) {
        fileURL = url
        guard let shotID = CaptureFolderManager.parseShotId(url: url) else {
            return nil
        }

        id = shotID
    }
}

extension ShotFileInfo: Identifiable { }
