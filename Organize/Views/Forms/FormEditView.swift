//
//  FormEditView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/10/24.
//

import OSLog
import SwiftUI
import SceneKit
import SwiftData
import CoreML

struct FormEditView<T>: View where T: Meta  {
    typealias ButtonAction = () -> Void
    typealias ButtonActionWithPlacementID = (UUID?) -> Void
    let model: MobileNetV2FP16?
    
    @Environment(\.modelContext) private var modelContext
    @Query var spaces: [Space]
    @Query var storages: [Storage]
    
    @Binding var target: T
    
    @State private var spaceSelection: Space? = nil
    @State private var storageSelection: Storage? = nil
    /// UUID that will be used to finding matching
    @State private var placementSelectionID: UUID?
    
    @State var isStyleDisclosureGroupExpanded = true
    @State var isInventoryListDisclosureGroupExpanded = true
    
    @State var generatedName: String? = nil
    
    var mode: FormMode = .add
    var title: String {
        guard let targetString = {
            switch target {
            case is Item:       "Item"
            case is Storage:    "Storage"
            case is Space:      "Space"
            default:            nil
            }
        }() else {
            logger.warning("Title is empty for FormEditView because Target is not a implemented type.")
            return ""
        }
        
        let modeString = mode.rawValue
        return (modeString + " an " + targetString)
    }
    var confirmationButtonString: String {
        switch mode {
        case .edit:
            "Done"
        case .add:
            "Add"
        case .create:
            "Create"
        }
    }
    var confirmationButtonDisabled: Bool {
        switch target {
        case is Item:
            storageSelection == nil
        case is Storage:
            spaceSelection == nil
        default: false
        }
    }
    var cancelationAction: ButtonAction?
    var confirmationAction: ButtonAction?
    var addScanAction: ButtonActionWithPlacementID?
    
    // MARK: Inits
    init(
        _ target: Binding<T>,
        mode: FormMode = .add,
        unsafePlacementSelectionID placementSelectionID: UUID? = nil,
        cancel cancelationAction: @escaping ButtonAction,
        confirm confirmationAction: @escaping ButtonAction
    ) {
        self._target = target
        self.mode = mode
        _placementSelectionID = State(initialValue: placementSelectionID)
        self.cancelationAction = cancelationAction
        self.confirmationAction = confirmationAction
        self.model = try? MobileNetV2FP16(configuration: MLModelConfiguration())
    }
    
    init(
        _ target: Binding<T>,
        mode: FormMode = .add,
        unsafePlacementSelectionID placementSelectionID: UUID? = nil,
        addScan addScanAction: @escaping ButtonActionWithPlacementID,
        cancel cancelationAction: @escaping ButtonAction,
        confirm confirmationAction: @escaping ButtonAction
    ) {
        self._target = target
        self.mode = mode
        _placementSelectionID = State(initialValue: placementSelectionID)
        self.addScanAction = addScanAction
        self.cancelationAction = cancelationAction
        self.confirmationAction = confirmationAction
        self.model = try? MobileNetV2FP16(configuration: MLModelConfiguration())
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: IconNameCard
                Section { 
                    IconNameCardView(target, generatedName: $generatedName)
                        .onAppear {
                            if let image = target.image{
                                withAnimation {
                                    generatedName = classifyImage(image)
                                }
                            }
                        }
                }
                
                // MARK: Add Scan Button
                switch target {
                case let item as Item:
                    Section {
                        if let item = target as? Item,
                           let previewImage = item.capture?.previewImage {
                            Image(uiImage: previewImage)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        Button {
                            withAnimation {
                                addScanAction?(storageSelection?.id)
                            }
                        } label: {
                            Label {
                                Text(item.capture == nil ? 
                                     "Add a Capture" : "Replace Capture")
                            } icon: {
                                Image(systemName: "cube.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.white)
                                    .frame(width: 28, height: 28)
                            }
                            .labelStyle(ShapedLabelStyle(shape: .roundedRectangle(6), scaleEffect: 0.6, backgroundColor: .mint))
                        }
                        .listRowBackground(target.color)
                        .buttonStyle(ListButtonStyle())
                        .disabled(addScanAction == nil)
                        if item.capture != nil {
                            
                        }
                    }
                default:
                    EmptyView()
                }

                // MARK: Placement Picker
                switch target {
                case is Storage:
                    Section {
                        Picker(selection: $spaceSelection) {
                            Text("No Selection").tag(nil as Space?)
                            ForEach(spaces) { space in
                                Text(space.name).tag(space as Space?)
                            }
                        } label: {
                            Label {
                                Text("Space")
                            } icon: {
                                Image(systemName: "square.split.bottomrightquarter")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.white)
                                    .frame(width: 28, height: 28)
                            }
                            .labelStyle(ShapedLabelStyle(shape: .roundedRectangle(6), scaleEffect: 0.6, backgroundColor: .pink))
                        }

                    }
                    .onAppear {
                        guard placementSelectionID != nil else {
                            logger.notice("placementSelectionID is nil leaving selection to empty")
                            return
                        }
                        guard let result = spaces.first(where: { $0.id == placementSelectionID }) else {
                            logger.warning("placementSelectionID is not nil but find no match in storage query")
                            return
                        }
                        logger.notice("Successfully matched placementSelectionID with a Storage in query")
                        spaceSelection = result
                    }
                case is Item:
                    Section {
                        Picker(selection: $storageSelection) {
                            Text("No Selection").tag(nil as Storage?)
                            ForEach(storages) { storage in
                                Text(storage.name).tag(storage as Storage?)
                            }
                        } label: {
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
                    .onAppear {
                        guard placementSelectionID != nil else {
                            logger.notice("placementSelectionID is nil leaving selection to empty")
                            return
                        }
                        guard let result = storages.first(where: { $0.id == placementSelectionID }) else {
                            logger.warning("placementSelectionID is not nil but find no match in storage query")
                            return
                        }
                        logger.notice("Successfully matched placementSelectionID with a Storage in query")
                        storageSelection = result
                    }
                default:
                    EmptyView()
                }
                
                // MARK: Inventory list
                if let space = target as? Space,
                    space.storages.count > 0 {
                    Section {
                        DisclosureGroup(
                            isExpanded: $isInventoryListDisclosureGroupExpanded
                        ) {
                            ForEach(space.storages) { storage in
                                Text(storage.name)
                            }
                        } label: {
                            Label {
                                Text(space.storages.count == 1 ?
                                     "Storage" : "Storages")
                            } icon: {
                                Image(systemName: "archivebox")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.white)
                                    .frame(width: 28, height: 28)
                            }
                            .labelStyle(ShapedLabelStyle(shape: .roundedRectangle(6), backgroundColor: .orange))
                        }
                    }
                }
                
                // MARK: Styles
                DisclosureGroup(isExpanded: $isStyleDisclosureGroupExpanded) {
                } label: {
                    Label { "Styles".inText
                    } icon: {
                        Image(systemName: "paintbrush")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.white)
                            .frame(width: 28, height: 28)
                    }
                    .labelStyle(ShapedLabelStyle(shape: .roundedRectangle(6), backgroundColor: .green))
                }
                if isStyleDisclosureGroupExpanded {
                    Section { ColorSelectionGridView($target.color) }
                    Section {
                        switch target {
                        case let item as Item:
                            let symbol = Binding {
                                item.symbol
                            } set: { newSymbol in
                                item.symbol = newSymbol
                            }
                            IconSelectionGridView(symbol, presetIcons: Item.symbolList)
                        default:
                            EmptyView()
                        }
                    }
                    Section("Pattern") {
                        PatternSelectionView(
                            $target.pattern,
                            color: target.color)
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if let confirmationAction {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(confirmationButtonString) {
                            savePlacement()
                            confirmationAction()
                        }
                        .disabled(confirmationButtonDisabled)
                    }
                }
                                
                if let cancelationAction {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            cancelationAction()
                        }
                    }
                }
                
            }
        }
        .tint(target.color)
        .ignoresSafeArea()
    }
    
    func savePlacement() {
        switch target {
        case let storage as Storage:
            storage.space = spaceSelection
        case let item as Item:
            item.storage = storageSelection
            return
        default:
            return
        }
    }
    
    //TODO: This should become an extension to the model class
    private func classifyImage(_ image: UIImage) -> String? {
        guard let resizedImage = image.resizeImageTo(size:CGSize(width: 224, height: 224)),
              let buffer = resizedImage.convertToBuffer() else {
              return nil
        }
        
        let output = try? model?.prediction(image: buffer)
        
        if let output = output {
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
            let result = results.map { (key, value) in
                return "\(key) = \(String(format: "%.2f", value * 100))%"
            }.joined(separator: "\n")

            return result
        }
        return nil
    }
}

extension FormEditView {
    enum FormMode: String {
        case edit   = "Edit"
        case add    = "Add"
        case create = "Create"
    }
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "FormEditView")

#Preview {
    FormEditView(
        .constant(
            Item(name: "My Item")
        ), cancel:  {
            print("Cancelled")
        }, confirm: {
            print("Confirmmed")
        })
}
