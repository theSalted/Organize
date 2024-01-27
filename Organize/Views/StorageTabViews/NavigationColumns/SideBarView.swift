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
            GeometryReader { geometry in
                TimelineView(.animation) { timeline in
                    let x = geometry.size.width
                    let y = geometry.size.height
                    let t = timeline.date.timeIntervalSinceReferenceDate
                    let a = t.remainder(dividingBy: 360)
                    let v = (sin(t) + 1)/2
                    
                    let t2 = timeline.date.timeIntervalSince1970 - Date().timeIntervalSince1970
                    let speed: CGFloat = 1
                    let amplitude: CGFloat = 5
                    let frequency: CGFloat = 2
                    
                    Rectangle().fill(.fishScale(
                        foregroundColor: .accentColor.opacity(0.3),
                        backgroundColor: backgroundColor,
                        radius: 26,
                        thickness: v - 0.5,
                        angle: .degrees(a * 0.5)
                    ))
                    .fill(LinearGradient(
                        colors:
                            [backgroundColor,
                             backgroundColor.opacity(0.8),
                             .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing))
                    .ignoresSafeArea()
                    Group {
                        Circle()
                            .fill(Color.accentColor.gradient.opacity(0.2)).blur(radius: 20 + (v * 30))
                            .scaleEffect((v * 0.7) + 1.3)
                            .offset(x: -x/(2 + 1 * v), y: -y/(1 + v * 0.3))
                            
                        Circle()
                            .fill(Color.accentColor.gradient.opacity(0.2)).blur(radius: 30 + (v * 70))
                            .scaleEffect((v * 0.7) - 1.3)
                            .offset(x: v * 0.5 + 0.5, y: -y/(1 + v * 0.1))
                            .ignoresSafeArea()
                    }
                    .distortionEffect(
                        .init(
                            function: .init(library: .default, name: "wave"),
                            arguments: [
                                .float(t2),
                                .float(speed),
                                .float(frequency),
                                .float(amplitude)
                            ]
                        ),
                        maxSampleOffset: .zero
                    )
                }
            }
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
