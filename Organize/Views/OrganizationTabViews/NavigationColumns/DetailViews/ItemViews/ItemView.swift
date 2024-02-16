//
//  ItemView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/16/24.
//

import SwiftUI
import SwiftData

struct ItemView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppViewModel.self) private var appModel
    @Query private var items: [Item]
    var selectedItems: [Item] {
        items.filter { appModel.itemsListSelectionIDs.contains($0.id) }
    }
    
    var title: String {
        switch selectedItems.count {
        case 1:
            selectedItems.first?.name ?? "Item"
        case 2:
            "\(selectedItems[0].name) and \(selectedItems[1].name) Items"
        case 3...:
            "\(selectedItems[0].name) and \(selectedItems.count - 1) More Items"
        default:
            "Item"
        }
    }
    
    var body: some View {
        VStack {
            switch selectedItems.count {
            case 0:
                ContentUnavailableView(
                    "Select an Item", systemImage: "cube", description: "Select one or more items to get started".inText)
            case 1:
                SingleItemDetailView(selectedItems.first!)
                    .navigationTitle(title)
            case 2...:
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300, maximum: .infinity), spacing: 15)]) {
                        ForEach(selectedItems) { item in
                            NavigationLink {
                                MetaInfoView(item)
                                    .navigationTitle(item.name)
                            } label: {
                                let color = item.color
                                VStack {
                                    PatternDesignView(item.pattern, patternColor: color)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(LinearGradient(colors: [color, .clear, .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                                                 .brightness(1.1)
                                        }
                                        .shadow(color: color.opacity(0.5), radius: 10)
                                        .frame(maxWidth: .infinity, minHeight: 200)
                                    Text(item.name)
                                        .font(.headline)
                                }
                            }.buttonStyle(.plain)
                        }
                    }.padding()
                }.navigationTitle(title)
            default:
                ContentUnavailableView(
                    "Something Went Wrong...",
                    systemImage: "exclamationmark.triangle",
                    description: "Number of selected item is outside of possible range. Please contact support, we are sorry for your inconvenience.".inText)
            }
        }.scrollContentBackground(.hidden)
    }
}

#Preview {
    ItemView()
        .environment(AppViewModel())
}
