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
    
    var storages: [Storage] {
        selectedSpaces.flatMap { space in
            space.storages
        }
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
        @Bindable var appModel = appModel
        
        VStack {
            switch selectedSpaces.count {
            case 1:
                let space = selectedSpaces.first!
                MetaInfoView(space).navigationTitle(title)
            case 2...:
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300, maximum: .infinity), spacing: 15)]) {
                        ForEach(selectedSpaces) { space in
                            NavigationLink {
                                MetaInfoView(space)
                                    .navigationTitle(space.name)
                            } label: {
                                let color = space.color
                                VStack {
                                    PatternDesignView(space.pattern, patternColor: color)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .overlay( /// apply a rounded border
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(LinearGradient(colors: [color, .clear, .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                                                 .brightness(1.1)
                                        )
                                        .shadow(color: color.opacity(0.5), radius: 10)
                                        .frame(maxWidth: .infinity, minHeight: 200)
                                    Text(space.name)
                                        .font(.headline)
                                }
                                
                            }
                            .buttonStyle(.plain)
                        }
                    }.padding()
                }
                .toolbarBackground(.clear, for: .navigationBar)
                .toolbarBackground(.hidden, for: .navigationBar)
                .navigationTitle(title)
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
