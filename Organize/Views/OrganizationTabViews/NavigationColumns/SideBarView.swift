//
//  SideBarView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/22/24.
//

import SwiftUI
import SwiftData

struct SideBarView: View {
    // Environments and SwiftData Queries
    @Environment(\.modelContext) private var modelContext
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(AppViewModel.self) private var appModel
    @Query private var spaces: [Space]
    
    // View States
    @State private var editMode: EditMode  = .inactive
    @State private var isSearchPresented   = false
    @State private var showCreateForm      = false
    @State private var searchText          = ""
    
    let backgroundColor = Color(uiColor: UIColor.secondarySystemBackground)
    
    /// A list of spaces available for display on side bar, this taken in account of searchText and other vectors
    private var spacesList: [Space] {
        if searchText.isEmpty {
            return spaces
        } else {
            // TODO: Improve needed for the match algorithm in this computed property
            // -[ ] Better fuzzy match algorithm
            // -[ ] Implementation in generic of string extension
            return spaces.filter { space in
                space.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        @Bindable var appModel = appModel
        
        List(selection: $appModel.spaceListSelectionIDs) {
            // Tab bar hide itself when device is in horizontal. Switch tab with a button instead.
            if verticalSizeClass == .compact && !isSearchPresented {
                Label("Scan", systemImage: "cube.fill")
            }
            
            Section(spacesList.isEmpty ? "" : "Space") {
                ForEach(spacesList) { space in
                    Label {
                        Text(space.name)
                    } icon: {
                        SymbolView(symbol: space.symbol)
                            .foregroundStyle(space.color)
                    }
                        
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
                .symbolEffect(.bounce, value: showCreateForm)
                .sensoryFeedback(.success, trigger: showCreateForm)
            }
        }
        .overlay {
            // Placeholder View for when spaces is empty
            if spacesList.isEmpty {
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
        .sheet(isPresented: $showCreateForm) {
            @State var space = Space(name: "My Space")
            
            FormEditView($space, mode: .create) {
                withAnimation {
                    showCreateForm = false
                }
            } confirm: {
                withAnimation {
                    showCreateForm = false
                    modelContext.insert(space)
                }
                try? modelContext.save()
            }
        }
        .searchable(text: $searchText, isPresented: $isSearchPresented)
        
    }
    
    private func addSpace() {
        withAnimation {
            showCreateForm = true
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
    NavigationStack {
        SideBarView()
            .environment(AppViewModel())
    }
}
