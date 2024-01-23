//
//  SpaceListView.swift
//  Storage
//
//  Created by Yuhao Chen on 1/22/24.
//

import SwiftUI
import SwiftData

struct SpaceListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(AppViewModel.self) private var appModel
    @Query private var spaces: [Space]
    @State private var isSearchPresented = false
    @State private var showAddTitleForm = false
    @State private var newSpaceName = ""
    @State private var selection: Set<String> = []
    @State private var searchText = ""
    
    
    private var searchedSpaces : [Space] {
        if searchText.isEmpty {
            return spaces
        } else {
            return spaces.filter { $0.name?.contains(searchText) ?? false }
        }
    }
    
    var body: some View {
        @Bindable var appModel = appModel
        List(selection: $appModel.spaceListSelections) {
            // Tab bar hide itself when device is in horizontal. Switch tab with a button instead.
            if verticalSizeClass == .compact && !isSearchPresented {
                Button {
                    appModel.tabViewSelection = AppViewModel.TabViewTag.scan
                } label : {
                    Label("Scan", systemImage: "cube.fill")
                }
            }
            
            Section(searchedSpaces.isEmpty ? "" : "Space") {
                ForEach(searchedSpaces) { space in
                    Text(space.name ?? "Untitled")
//                    NavigationLink( {
//                        SpaceView(space: space)
//                    } label: {
//                        Text(space.name ?? "Untitled")
//                    }
                }
                .onDelete(perform: deleteItems)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Menu {
                    EditButton()
                } label: {
                    Label("More options", systemImage: "ellipsis.circle")
                }

            }
            ToolbarItem {
                Button(action: addSpace) {
                    Image(systemName: "plus.circle.fill")
                        .accessibilityLabel("Add space")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title2)
                }
            }
        }
        .overlay {
            // Placeholder View for when spaces is empty
            if searchedSpaces.isEmpty {
                if searchText.isEmpty{
                    ContentUnavailableView("Start Organizing", systemImage: "shippingbox.fill", description: Text("Create your first space. Tap the plus button to get started."))
                } else {
                    ContentUnavailableView.search(text: searchText)
                }
            }
        }
        .navigationTitle("Storage")
        .alert("Add Space", isPresented: $showAddTitleForm) {
            TextField("Enter your Space Name", text: $newSpaceName)
            Button("Cancel") {
                withAnimation {
                    showAddTitleForm = false
                }
            }
            Button("Ok") {
                createSpace(newSpaceName)
            }
        }
        .searchable(text: $searchText, isPresented: $isSearchPresented)
    }
    
    private func addSpace() {
        withAnimation {
            showAddTitleForm = true
        }
    }

    private func createSpace(_ name: String) {
        withAnimation {
            let newItem = Space(name: name)
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(spaces[index])
            }
        }
    }
}

#Preview {
    SpaceListView()
}
