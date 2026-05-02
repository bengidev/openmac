//
//  WorkspaceSelectorLabel.swift
//  OpenMac
//
//  Created by Bambang Tri Rahmat Doni on 02/05/26.
//

import SwiftUI

struct WorkspaceSelectorLabel: View {
    let workingDirectoryName: String
    let isWorkspaceSelected: Bool

    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: isWorkspaceSelected ? "folder" : "folder.badge.xmark")
                .font(.system(size: 12, weight: .medium))

            Text(workingDirectoryName)
                .font(.caption)
                .lineLimit(1)

            Image(systemName: "chevron.down")
                .font(.system(size: 8, weight: .semibold))
        }
        .foregroundStyle(Color.primary.opacity(0.62))
        .padding(.vertical, 9)
        .padding(.horizontal, 12)
        .background(.white.opacity(0.04), in: .capsule)
        .contentShape(Capsule())
    }
}

#Preview("Workspace Selector Label") {
    WorkspaceSelectorLabel(
        workingDirectoryName: "OpenMac",
        isWorkspaceSelected: true
    )
    .padding(24)
    .background(.black)
    .preferredColorScheme(.dark)
}
