//
//  View+AdaptiveNavigationTitle.swift
//  Storage
//
//  Created by Yuhao Chen on 1/24/24.
//

import SwiftUI

/// `AdaptiveNavigationTitleModifier` is a custom ViewModifier that add a navigation title to current view, and allow you to specify when navigational title can be renamed
struct AdaptiveNavigationTitleModifier : ViewModifier {
    // Condition to determine if the title can be renamed.
    var condition : Bool

    // Binding to the title string, allowing it to be read and modified.
    @Binding var title : String
    
    /// Initializes the modifier with a binding to a title string and a condition.
    /// - Parameters:
    ///   - title: A Binding to the String that will be used as the navigation title.
    ///   - condition: A Boolean value that determines if the title can be changed.
    init(_ title: Binding<String>, canRename condition: Bool) {
        self.condition = condition
        self._title = title
    }
    
    /// Alternative initializer that takes a getter and setter for the title.
    /// - Parameters:
    ///   - condition: A Boolean value that determines if the title can be changed.
    ///   - get: A closure to get the current title string.
    ///   - set: A closure to set a new title string.
    init(canRename condition: Bool, get: String, set: @escaping (String) -> Void) {
        self.condition = condition
        self._title = Binding(get: { get }, set: set)
    }
    
    /// The body of the ViewModifier, determining how the view is modified.
    /// - Parameter content: The content of the view being modified.
    /// - Returns: A modified view with a conditional navigation title.
    func body(content: Content) -> some View {
        if condition {
            // If the condition is true, the title can be changed dynamically.
            // (i.e. you can rename it)
            content.navigationTitle($title)
        } else {
            // If the condition is false, a static title is used.
            content.navigationTitle(title)
        }
    }
}

extension View {
    /// Add a navigation title to current view, allow you to specify when navigational title can be renamed
    /// The title can dynamically change based on a condition.
    ///
    /// - Parameters:
    ///   - title: A binding to the String that will be used as the navigation title.
    ///   - condition: A Boolean value that determines if the title can be changed.
    /// - Returns: A view modified with an adaptive navigation title based on the given condition.
    func adaptiveNavigationTitle(_ title: Binding<String>, canRename condition: Bool) -> some View {
        // Applies the AdaptiveNavigationTitleModifier with the provided title and condition.
        modifier(AdaptiveNavigationTitleModifier(title, canRename: condition))
    }
    
    /// Add a navigation title to current view, allow you to specify when navigational title can be renamed
    /// This initializer allows for a more custom control of the title string.
    ///
    /// - Parameters:
    ///   - condition: A Boolean value that determines if the title can be changed.
    ///   - get: A closure to get the current title string.
    ///   - set: A closure to set a new title string.
    /// - Returns: A view modified with an adaptive navigation title that can be dynamically set.
    func adaptiveNavigationTitle(canRename condition: Bool, get: String, set: @escaping (String) -> Void) -> some View {
        // Applies the AdaptiveNavigationTitleModifier with a custom getter and setter for the title, along with the condition.
        modifier(AdaptiveNavigationTitleModifier(canRename: condition, get: get, set: set))
    }
}
