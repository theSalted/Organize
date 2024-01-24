//
//  DetailsView.swift
//  Storage
//
//  Created by Yuhao Chen on 1/24/24.
//

import SwiftUI

struct DetailsView<M:Meta>: View {
    var selections: Set<M.ID>
    var body: some View {
        ContentUnavailableView("Let's Get Organized", systemImage: Item.randomSystemSymbol, description: Text("Select an item or create your first one."))
    }
}
