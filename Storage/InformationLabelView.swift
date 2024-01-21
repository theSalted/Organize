//
//  InformationLabelView.swift
//  Storage
//
//  Created by Yuhao Chen on 1/22/24.
//

import SwiftUI

struct InformationLabelView: View {
    var label : String
    var content : String
    
    init(_ label: String, info content: String) {
        self.label = label
        self.content = content
    }
    
    var body: some View {
        HStack {
            Text(content)
                .foregroundStyle(.secondary)
            Spacer()
            Text(label)
        }
        .font(.caption)
        .padding(.vertical, 2)
    }
}

#Preview {
    InformationLabelView("Where", info: "Office")
}
