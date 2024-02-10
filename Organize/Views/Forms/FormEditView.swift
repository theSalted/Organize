//
//  FormEditView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/10/24.
//

import OSLog
import SwiftUI

struct FormEditView: View {
    typealias ButtonAction = () -> Void
    
    @Binding var target: any Meta
    
    @State var isStyleDisclosureGroupExpanded = true
    
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
    var confirmationButtonString: String {
        switch mode {
        case .edit:
            "Done"
        case .add:
            "Add"
        case .create:
            "Create"
        }
    }
    var cancelationAction: ButtonAction?
    
    var body: some View {
        NavigationStack {
            Form {
                List {
                    Section { IconNameCardView(target) }
                    
                    DisclosureGroup(isExpanded: $isStyleDisclosureGroupExpanded) {
                        Section { ColorSelectionGridView($target.color) }
                    } label: {
                        Label {
                            Text("Styles")
                        } icon: {
                            Image(systemName: "paintbrush")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.white)
                                .frame(width: 28, height: 28)
                        }
                        .labelStyle(ShapedLabelStyle(shape: .roundedRectangle(6), backgroundColor: .orange))
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(confirmationButtonString) {}
                        .disabled(true)
                }
                
                if let cancelationAction {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            cancelationAction()
                        }
                    }
                }
                
            }
        }
        .tint(target.color)
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
        )) {
            print("Cancelled")
        }
}
