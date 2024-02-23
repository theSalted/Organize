//
//  AlertError.swift
//  Organize
//
//  Created by Yuhao Chen on 2/24/24.
//

import Foundation

struct AlertError {
    var title: String = ""
    var message: String = ""
    var primaryButtonTitle = "Accept"
    var secondaryButtonTitle: String?
    var primaryAction: (() -> ())?
    var secondaryAction: (() -> ())?
    
    init(title: String = "", message: String = "", primaryButtonTitle: String = "Accept", secondaryButtonTitle: String? = nil, primaryAction: (() -> ())? = nil, secondaryAction: (() -> ())? = nil) {
        self.title = title
        self.message = message
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
}
