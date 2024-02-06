//
//  ItemAddFormView+Design.swift
//  Organize
//
//  Created by Yuhao Chen on 2/6/24.
//

import SwiftUI

private struct ItemAddFormViewDesign: View {
    var title : String { "Add an item" }
    var color : Color = .pink
    var symbol : String = "soccerball"
    var body: some View {
        NavigationStack {
            Form {
                List {
                    Section {
                        VStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .foregroundStyle(color.gradient)
                                Image(systemName: symbol)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(20)
                                    .foregroundStyle(.white)
                            }
                                .frame(height: 90)
                            TextField("Name", text: .constant(String()))
                                .textFieldStyle(.roundedBorder)
                        }.padding(.vertical, 7)
                    }
                    Section {
                        // Picker styles in Menu is pretty cool but this kinda
                        // need to be in
                        Picker(selection: .constant(0)) {
                            Text("Table ") + Text("(Bedroom)")
                            Text("Storage 2 ") + Text("(Living Room)")
                            Text("Storage Bin 1 ") + Text("(Garage)")
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
                    DisclosureGroup(
                        content: {
                            Section {
                                Grid(horizontalSpacing: 30, verticalSpacing: 20) {
                                    GridRow {
                                        Circle().foregroundStyle(.red)
                                            .frame(height: 30)
                                        Circle().foregroundStyle(.orange)
                                            .frame(height: 30)
                                        Circle().foregroundStyle(.yellow)
                                            .frame(height: 30)
                                        Circle().foregroundStyle(.green)
                                            .frame(height: 30)
                                        Circle().foregroundStyle(.cyan)
                                            .frame(height: 30)
                                        Circle().foregroundStyle(.blue)
                                            .frame(height: 30)

                                    }
                                    
                                    GridRow {
                                        Circle().foregroundStyle(.purple)
                                            .frame(height: 30)
                                        Circle().foregroundStyle(.pink)
                                            .frame(height: 30)
                                        Circle().foregroundStyle(.mint)
                                            .frame(height: 30)
                                        Circle().foregroundStyle(.brown)
                                            .frame(height: 30)
                                        Circle().foregroundStyle(.gray)
                                            .frame(height: 30)
                                        ColorPicker("Color", selection: .constant(.accent))
                                            .labelsHidden()
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 5)
                            }
                            
                            Section {
                                Grid(horizontalSpacing: 20, verticalSpacing: 20) {
                                    GridRow {
                                        ForEach(0...5, id: \.self) { _ in
                                            ZStack {
                                                Circle()                                            .foregroundStyle(Color(uiColor: UIColor.secondarySystemBackground))
                                                Image(systemName: Item.randomSystemSymbol)
                                            }
                                                .frame(height: 40)
                                        }

                                    }
                                    GridRow {
                                        GridRow {
                                            ForEach(0...5, id: \.self) { _ in
                                                ZStack {
                                                    Circle()                                            .foregroundStyle(Color(uiColor: UIColor.secondarySystemBackground))
                                                    Image(systemName: Item.randomSystemSymbol)
                                                }
                                                    .frame(height: 40)
                                            }

                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 5)
                            }
                        },
                        label: {
                            Label {
                                Text("Styles")
                            } icon: {
                                Image(systemName: "paintbrush")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.white)
                                    .frame(width: 28, height: 28)
                            }
                            .labelStyle(ShapedLabelStyle(shape: .roundedRectangle(6), backgroundColor: .orange))
                        }
                    )
                    
                }
                .listSectionSpacing(15)
                
                
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { }
                        .disabled(true)
                }
            }
        }
        .ignoresSafeArea()
    }
    
    var colorGridTestView : some View {
        Section {
            LazyHGrid(rows: [GridItem(.fixed(30.00), spacing: 15), GridItem(.fixed(30.00), spacing: 15)], spacing: 20, content: {
                Circle().foregroundStyle(.red)
                Circle().foregroundStyle(.orange)
                Circle().foregroundStyle(.yellow)
                Circle().foregroundStyle(.green)
                Circle().foregroundStyle(.mint)
                Circle().foregroundStyle(.cyan)
                Circle().foregroundStyle(.blue)
                Circle().foregroundStyle(.red)
                Circle().foregroundStyle(.orange)
                Circle().foregroundStyle(.yellow)
                Circle().foregroundStyle(.green)
                Circle().foregroundStyle(.mint)
                Circle().foregroundStyle(.cyan)
                Circle().foregroundStyle(.blue)
                ColorPicker("Color", selection: .constant(.accent))
                    .labelsHidden()
            })
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview { 
    Spacer()
        .sheet(isPresented: .constant(true)) {
            ItemAddFormViewDesign()
        }
}

#Preview {
    ItemAddFormViewDesign()
}


fileprivate struct Playground {
    func metaGenericTest(target: any Meta) {
        let space = target as? Space
        print(space?.systemImage ?? "")
    }
    
    func whatIsInsideItem() {
        let item = Item(name: "My Item")
        print(item.color)
        print(item.createdAt)
        print(item.name)
    }
}
