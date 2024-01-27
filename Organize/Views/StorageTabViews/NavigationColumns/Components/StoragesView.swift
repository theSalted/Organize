//
//  StorageView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/21/24.
//

import SwiftUI
import SwiftData

struct StoragesView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppViewModel.self) private var appModel
    @Query private var storages: [Storage]

    var selectedStorages: [Storage] {
        storages.filter { appModel.storageListSelections.contains($0.id) }
    }
    
    var title : String {
        switch selectedStorages.count {
        case 1:
            selectedStorages.first?.name ?? "Storages"
        case 2:
            "\(selectedStorages[0].name) and \(selectedStorages[1].name)"
        case 3...:
            "\(selectedStorages[0].name) and \(selectedStorages.count - 1) More"
        default:
            "Storages"
        }
    }

    var body: some View {
        VStack {
            switch selectedStorages.count {
            case 0:
                ContentUnavailableView(
                    "Select a Storage",
                    systemImage: "archivebox",
                    description: Text("Select one or multiple storages to get started."))
            case 1: // Single Item selected
                MetaInfoView(selectedStorages.first!)
                    .navigationTitle(title)
            case 2...: // Multiple Item selected
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300, maximum: .infinity), spacing: 15)]) {
                        ForEach(selectedStorages) { storage in
                            NavigationLink {
                                MetaInfoView(storage)
                            } label: {
                                VStack {
                                    Image(systemName: "soccerball")
                                        .frame(maxWidth: .infinity, minHeight: 200)
                                        .background {
                                            Rectangle().fill(.fishScale(
                                                foregroundColor: .white,
                                                backgroundColor: .blue.opacity(0.3),
                                                radius: 26,
                                                thickness: 1.5,
                                                angle: .degrees(12)
                                            ))
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                    Text(storage.name)
                                        .font(.headline)
                                }
                                
                            }
                            .buttonStyle(.plain)
                        }
                    }.padding()
                }
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
    StoragesView()
        .environment(AppViewModel())
}
