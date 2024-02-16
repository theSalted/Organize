//
//  SpaceView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/21/24.
//

import SwiftUI
import SwiftData

struct SpaceView: View {
    @Environment(AppViewModel.self) private var appModel
    @Query private var spaces: [Space]
    
    var selectedSpaces: [Space] {
        spaces.filter { appModel.spaceListSelectionIDs.contains($0.id) }
    }

    var title : String {
        switch selectedSpaces.count {
        case 1:
            (selectedSpaces.first?.name ?? "Space") + " Detail"
        case 2:
            "\(selectedSpaces[0].name) and \(selectedSpaces[1].name) Spaces"
        case 3...:
            "\(selectedSpaces[0].name) and \(selectedSpaces.count - 1) More Spaces"
        default:
            "Storages"
        }
    }
    
    var body: some View {
        VStack {
            switch selectedSpaces.count {
            case 0:
                ContentUnavailableView(
                    "Select an Space",
                    systemImage: "square.split.bottomrightquarter",
                    description: "Select one or more spaces to get started".inText)
            case 1:
                MetaInfoView(selectedSpaces.first!).navigationTitle(title)
            case 2...:
                ScrollView {
                    MetaGridView(selectedSpaces).padding()
                }.navigationTitle(title)
            default:
                ContentUnavailableView(
                    "Something Went Wrong...",
                    systemImage: "exclamationmark.triangle",
                    description: "Number of selected space is outside of possible range. Please contact support, we are sorry for your inconvenience.".inText)
            }
        }
    }
}

#Preview {
    SpaceView()
}
