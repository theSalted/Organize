//
//  SideBarView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/22/24.
//

import SwiftUI
import SwiftData

struct SideBarView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(AppViewModel.self) private var appModel
    @Query private var spaces: [Space]
    @State private var editMode: EditMode  = .inactive
    @State private var isSearchPresented   = false
    @State private var showAddTitleForm    = false
    @State private var newSpaceName        = ""
    @State private var searchText          = ""
    var backgroundColor = Color(uiColor: UIColor.secondarySystemBackground)
    
    private var searchedSpaces : [Space] {
        if searchText.isEmpty {
            return spaces
        } else {
            return spaces.filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        @Bindable var appModel = appModel
        List(selection: $appModel.spaceListSelections) {
            // Tab bar hide itself when device is in horizontal. Switch tab with a button instead.
            if verticalSizeClass == .compact && !isSearchPresented {
                Label("Scan", systemImage: "cube.fill")
            }
            
            Section(searchedSpaces.isEmpty ? "" : "Space") {
                ForEach(searchedSpaces) { space in
                    Text(space.name)
                }
                .onDelete(perform: deleteItems)
            }
        }
        .environment(\.editMode, $editMode)
        .scrollContentBackground(.hidden)
        .background {
            PatternDesignView(
                .init(pattern: .fishScale,
                      patternAnimationDirection: .counterClockwise,
                      auroraAnimationStyle: .dipFromTop,
                      auroraShape: .jelly,
                      auroraBlurStyle: .halo,
                      opacityStyle: .light,
                      gradientEffect: .topLeadingToBottomTrailing),
                patternColor: .accentColor,
                backgroundColor: Color(uiColor: UIColor.secondarySystemBackground))
            .ignoresSafeArea()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit Button", systemImage: "checklist.unchecked") {
                    withAnimation {
                        if editMode == .active {
                            editMode = .inactive
                        } else {
                            editMode = .active
                        }
                    }
                }
                .symbolEffect(.bounce, value: editMode)
                .symbolRenderingMode(.hierarchical)
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: addSpace) {
                    Image(systemName: "plus.circle.fill")
                        .accessibilityLabel("Add space")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title2)
                }
                .symbolEffect(.bounce, value: showAddTitleForm)
                .sensoryFeedback(.success, trigger: showAddTitleForm)
            }
        }
        .overlay {
            // Placeholder View for when spaces is empty
            if searchedSpaces.isEmpty {
                if searchText.isEmpty{
                    ContentUnavailableView(
                        "Start Organizing",
                        systemImage: "shippingbox.fill",
                        description: Text("Create your first space. " +
                                          "Tap the plus button to get started."))
                } else {
                    ContentUnavailableView.search(text: searchText)
                }
            }
        }
        .navigationTitle("Organize")
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
    SideBarView()
        .environment(AppViewModel())
}
