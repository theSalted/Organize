//
//  SingleSpaceDetailView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/24/24.
//

import Foundation
import SwiftUI
import MapKit

struct SingleSpaceDetailView: View {
    var space: Space
    
    init(_ space: Space) {
        self.space = space
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 15) {
                HStack(spacing: 10) {
                    // MARK: IconAndNameCard
                    IconNameCardView(space, mode: .display)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    // MARK: MAP
                    if let location = space.location {
                        let position = MapCameraPosition.region(
                            MKCoordinateRegion(
                                center: location,
                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                            )
                        )
                        Map(initialPosition: position) {
                            Marker(coordinate: location) {
                                Label {
                                    Text(space.name)
                                } icon: {
                                    SymbolView(symbol: space.symbol)
                                }
                                .font(.title)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .frame(height: 250)
                
                if let image = space.image {
                    ZStack {
                        Rectangle()
                            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                            .clipped()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                HStack(spacing: 10) {
                    CurtainStack(folds: 10) {
                        GroupBox {
                            MetaPrimitiveView(space, title: "Information")
                        }
                    } background: {
                        Text("Hey! You found me.")
                    }
                }
                .gridCellColumns(2)
            }
            .padding()
        }
    }
}


#Preview {
    SingleSpaceDetailView(Space(name: "My Space"))
}
