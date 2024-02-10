//
//  FormEditView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/10/24.
//

import SwiftUI

struct FormEditView: View {
    @Binding var target: any Meta
    var body: some View {
        NavigationStack {
            Form {
                List {
                    
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    FormEditView(
        target: .constant(
            Item(name: "My Item")
        )
    )
}
