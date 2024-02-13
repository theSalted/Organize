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
        .sheet(isPresented: $showAddTitleForm) {
            var space = Space(name: "My Space")
            
            let target = Binding {
                space as (any Meta)
            } set: { newSpaceValue in
                space = newSpaceValue as! Space
            }
            
            FormEditView(target: target) {
                withAnimation {
                    showAddTitleForm = false
                }
            } confirmationAction: {
                withAnimation {
                    showAddTitleForm = false
                    modelContext.insert(space)
                }
                try? modelContext.save()
            }

        }
        .searchable(text: $searchText, isPresented: $isSearchPresented)
        
    }
    
    private func addSpace() {
        withAnimation {
            showAddTitleForm = true
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
