//
//  ActivityViewControllerRepresentable.swift
//  Organize
//
//  Created by Yuhao Chen on 2/21/24.
//

import SwiftUI

/// A view controller  representable that you use to offer standard services from your app.
/// # Overview
/// The system provides several standard services, such as copying items to the pasteboard, posting content to social media sites, sending items via email or SMS, and more. Apps can also define custom services.
/// Your app is responsible for configuring, presenting, and dismissing this view controller. Configuration for the view controller involves specifying the data objects on which the view controller should act. (You can also specify the list of custom services your app supports.) When presenting the view representable, you must do so using the appropriate means for the current device. On iPad, you must present the view controller in a popover. On iPhone and iPod touch, you must present it modally.
/// # Note
/// This is an implementation of UIActivityViewController for SwiftUI.
///
/// See [UIActivityViewController](https://developer.apple.com/documentation/uikit/uiactivityviewcontroller)
struct ActivityViewControllerRepresentable: UIViewControllerRepresentable {
    var items: [Any]
    var activities : [UIActivity]?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: activities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

