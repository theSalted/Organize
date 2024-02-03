//
//  URL+isDirectory.swift
//  Organize
//
//  Created by Yuhao Chen on 2/3/24.
//

import Foundation

extension URL {
    var isDirectory: Bool {
       (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
