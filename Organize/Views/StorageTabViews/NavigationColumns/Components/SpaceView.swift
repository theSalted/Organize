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
        spaces.filter { appModel.spaceListSelections.contains($0.id) }
    }
    
    var storages: [Storage] {
        selectedSpaces.flatMap { space in
            space.storages
        }
    }
    
    var title : String {
        switch selectedSpaces.count {
        case 1:
            selectedSpaces.first?.name ?? "Storages"
        case 2:
            "\(selectedSpaces[0].name) and \(selectedSpaces[1].name)"
        case 3...:
            "\(selectedSpaces[0].name) and \(selectedSpaces.count - 1) More"
        default:
            "Storages"
        }
    }
    
    var body: some View {
        @Bindable var appModel = appModel
        
        VStack {
            switch selectedSpaces.count {
            case 0:
                List(selection: $appModel.storageListSelections) {
                    Section(storages.isEmpty
                            ? ""
                            : "^[\(storages.count) storage details](inflect: true) in ^[\(selectedSpaces.count) spaces](inflect: true)") {
                        ForEach(storages) { storage in
                            MetaPrimitiveView(storage)
                        }
                        .listRowSpacing(10)
                    }
                }
                .toolbarBackground(Color.pink, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationTitle(title)
                .listStyle(.inset)
            case 1:
                let space = selectedSpaces.first!
                MetaInfoView(space)
                    .background {
                        LinearGradient(
                            colors: [space.color,
                                     Color(uiColor: UIColor.systemBackground),
                                     Color(uiColor: UIColor.systemBackground)
                                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                    }
            case 2...:
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300, maximum: .infinity), spacing: 15)]) {
                        ForEach(selectedSpaces) { space in
                            NavigationLink {
                                MetaInfoView(space)
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
                    description: Text("Please contact support, we are sorry for your inconvenience."))
            }
        }
    }
}

#Preview {
    SpaceView()
}
