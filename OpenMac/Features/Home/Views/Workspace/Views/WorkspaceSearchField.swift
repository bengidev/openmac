//
//  WorkspaceSearchField.swift
//  OpenMac
//
//  Created by Bambang Tri Rahmat Doni on 02/05/26.
//

import SwiftUI

struct WorkspaceSearchField: View {
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)

            TextField("Search projects", text: $searchText)
                .textFieldStyle(.plain)
                .font(.caption)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(.white.opacity(0.06), in: .rect(cornerRadius: 10))
    }
}

#Preview("Workspace Search Field") {
    WorkspaceSearchField(searchText: .constant("OpenMac"))
        .padding(24)
        .frame(width: 320)
        .background(.black)
        .preferredColorScheme(.dark)
}
