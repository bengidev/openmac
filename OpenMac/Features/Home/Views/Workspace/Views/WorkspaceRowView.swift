//
//  WorkspaceRowView.swift
//  OpenMac
//
//  Created by Bambang Tri Rahmat Doni on 02/05/26.
//

import Foundation
import SwiftUI

struct WorkspaceRowView: View {
    let workspaceURL: URL
    let selectedWorkspaceURL: URL?
    let selectWorkspace: (URL) -> Void

    private var isSelected: Bool {
        selectedWorkspaceURL?.standardizedFileURL.path == workspaceURL.standardizedFileURL.path
    }

    private var displayName: String {
        let name = workspaceURL.lastPathComponent
        return name.isEmpty ? workspaceURL.path : name
    }

    var body: some View {
        Button {
            selectWorkspace(workspaceURL)
        } label: {
            HStack(spacing: 9) {
                Image(systemName: "folder")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.primary.opacity(0.66))

                Text(displayName)
                    .font(.caption)
                    .foregroundStyle(Color.primary.opacity(0.78))
                    .lineLimit(1)

                Spacer(minLength: 12)

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.primary.opacity(0.78))
                }
            }
            .padding(.vertical, 7)
            .padding(.horizontal, 9)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                isSelected ? .white.opacity(0.08) : .clear,
                in: .rect(cornerRadius: 8)
            )
            .contentShape(.rect(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

#Preview("Workspace Row View") {
    WorkspaceRowView(
        workspaceURL: URL(fileURLWithPath: "/Users/beng/Documents/iOS Projects/OpenMac", isDirectory: true),
        selectedWorkspaceURL: URL(fileURLWithPath: "/Users/beng/Documents/iOS Projects/OpenMac", isDirectory: true),
        selectWorkspace: { _ in }
    )
    .padding(24)
    .frame(width: 320)
    .background(.black)
    .preferredColorScheme(.dark)
}
