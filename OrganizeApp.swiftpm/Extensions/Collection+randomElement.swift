//
//  Collection+randomElement.swift
//  Organize
//
//  Created by Yuhao Chen on 1/28/24.
//

import Foundation
import OSLog

extension Collection {
    /// Returns a random element from the collection, or a specified default element if the collection is empty.
    ///
    /// This method enhances the standard `randomElement()` by providing a fallback value, ensuring that a value is returned even if the collection is empty.
    /// This is particularly useful for collections that are expected to always provide a value when accessed randomly,
    /// such as when selecting a random enum case where all cases are known and non-empty collections are expected.
    ///
    /// - Parameter defaultElement: The element to return if the collection is empty. T
    /// his ensures that the method always returns a value,
    /// preventing the need for optional binding or unwrapping in contexts where a non-optional result is required.
    /// - Returns: A random element from the collection if it is non-empty; otherwise, the `defaultElement` is returned.
    ///
    /// Example usage:
    /// ```
    /// enum MyEnum {
    ///     case optionOne, optionTwo, optionThree
    /// }
    ///
    /// let randomOption = MyEnum.allCases.randomElement(or: .optionOne)
    /// ```
    ///
    /// - Note: The method uses the system's random number generator to select the element.
    /// The default element is used only if the collection is completely empty,
    /// which should be a rare case for static collections like enum cases.
    /// - Warning: You should default using default system `randomElement()` when possible and
    /// the method would log a warning if default element is returned
    func randomElement(or defaultElement: Element) -> Element {
        guard let randomElement = self.randomElement() else {
            logger.warning("Couldn't find get a random element from \(Element.Type.self), returning to default")
            return defaultElement
        }
        return randomElement
    }
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "Collection+randomElement")
