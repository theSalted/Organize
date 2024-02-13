//
//  ItemPlacementPickerView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/12/24.
//

import SwiftUI
import SwiftData

struct ItemPlacementPickerView: View {
    @Binding var selection: Item
    @Query private var storages: [Storage]
    
    var body: some View {
        if storages.isEmpty {
            NavigationLink {
                ContentUnavailableView(
                    "Create a storage first",
                    systemImage: "square.split.bottomrightquarter",
                    description: "No storage available for your item.".inText)
                    .navigationTitle("Storage")
            } label: {
                pickerLabel
            }

        } else {
            Picker(selection: $selection) {
                ForEach(storages) { storage in
                    Text(storage.name)
                        .id(storage)
                }
            } label: {
                pickerLabel
            }.pickerStyle(.navigationLink)
        }
    }
    
    var pickerLabel: some View {
        Label {
            Text("Storage")
        } icon: {
            Image(systemName: "archivebox")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
        }
        .labelStyle(ShapedLabelStyle(shape: .roundedRectangle(6), scaleEffect: 0.6, backgroundColor: .pink))
    }
}

#Preview {
    NavigationStack {
        List {
            ItemPlacementPickerView(selection: .constant(Item(name: "My Item ")))
        }
    }
}
