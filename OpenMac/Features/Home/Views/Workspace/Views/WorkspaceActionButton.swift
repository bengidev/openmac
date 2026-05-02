//
//  WorkspaceActionButton.swift
//  OpenMac
//
//  Created by Bambang Tri Rahmat Doni on 02/05/26.
//

import SwiftUI

struct WorkspaceActionButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 9) {
                Image(systemName: systemImage)
                    .font(.system(size: 13, weight: .medium))

                Text(title)
                    .font(.caption)

                Spacer(minLength: 0)
            }
            .foregroundStyle(Color.primary.opacity(0.78))
            .padding(.vertical, 7)
            .padding(.horizontal, 9)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(.rect(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

#Preview("Workspace Action Button") {
    WorkspaceActionButton(
        title: "Add new project",
        systemImage: "folder.badge.plus",
        action: {}
    )
    .padding(24)
    .frame(width: 320)
    .background(.black)
    .preferredColorScheme(.dark)
}
