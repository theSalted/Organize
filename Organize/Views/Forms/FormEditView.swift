//
//  FormEditView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/10/24.
//

import OSLog
import SwiftUI

struct FormEditView: View {
    @Binding var target: any Meta
    var mode: FormMode = .add
    var title: String {
        guard let targetString = {
            switch target {
            case is Item:       "Item"
            case is Storage:    "Storage"
            case is Space:      "Space"
            default:            nil
            }
        }() else {
            logger.warning("Title is empty for FormEditView because Target is not a implemented type.")
            return ""
        }
        
        let modeString = mode.rawValue
        return (modeString + " an " + targetString)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                List {
                   IconNameCardView(target)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .ignoresSafeArea()
    }
}

extension FormEditView {
    enum FormMode: String {
        case edit   = "Edit"
        case add    = "Add"
        case create = "Create"
    }
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "FormEditView")

#Preview {
    FormEditView(
        target: .constant(
            Item(name: "My Item")
        )
    )
}
