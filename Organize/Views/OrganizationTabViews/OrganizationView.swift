//
//  OrganizationView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/4/24.
//

import SwiftUI

struct OrganizationView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SideBarView()
        } content: {
            ContentColumnView()
        } detail: {
            DetailsView()
        }
    }
}


#Preview {
    OrganizationView()
}
