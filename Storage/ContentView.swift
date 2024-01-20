//
//  ContentView.swift
//  Storage
//
//  Created by Yuhao Chen on 1/21/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var spaces: [Space]
    @State private var showAddTitleForm = false
    @State private var newSpaceName = ""

    var body: some View {
        NavigationSplitView {
            List {
                Section(spaces.isEmpty ? "" : "Spaces") {
                    ForEach(spaces) { item in
                        NavigationLink {
                            Text(item.name ?? "Untitled")
                        } label: {
                            Text(item.name ?? "Untitled")
                        }
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
                if spaces.isEmpty {
                    ContentUnavailableView("Start Organizing", systemImage: "shippingbox.fill", description: Text("Create your first space. Tap the plus button to get started."))
                }
            }
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
            .navigationTitle("Storage")
        } detail: {
            // Placeholder when no space is selected
            ContentUnavailableView("Let's Get Organized", systemImage: "square.split.bottomrightquarter.fill", description: Text("Select a space."))
        }
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
    ContentView()
        .modelContainer(for: Space.self, inMemory: true)
}
