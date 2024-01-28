//
//  Collection+randomElement.swift
//  Organize
//
//  Created by Yuhao Chen on 1/28/24.
//

import Foundation
import OSLog

extension Collection {
    func randomElement(or defaultElement: Element) -> Element {
        guard let randomElement = self.randomElement() else {
            logger.warning("Couldn't find get a random element from \(Element.Type.self), returning to default")
            return defaultElement
        }
        return randomElement
    }
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "Collection+randomElement")
