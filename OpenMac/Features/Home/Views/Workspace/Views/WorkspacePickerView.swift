//
//  WorkspacePickerView.swift
//  OpenMac
//
//  Created by Bambang Tri Rahmat Doni on 02/05/26.
//

import Foundation
import SwiftUI

struct WorkspacePickerView: View {
    @Binding var searchText: String

    let workspaceURLs: [URL]
    let selectedWorkspaceURL: URL?
    let selectWorkspace: (URL) -> Void
    let chooseWorkspaceDirectory: () -> Void
    let clearWorkspace: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            WorkspaceSearchField(searchText: $searchText)

            ScrollView {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(workspaceURLs, id: \.standardizedFileURL.path) { workspaceURL in
                        WorkspaceRowView(
                            workspaceURL: workspaceURL,
                            selectedWorkspaceURL: selectedWorkspaceURL,
                            selectWorkspace: selectWorkspace
                        )
                    }
                }
            }
            .frame(maxHeight: 260)

            Divider()
                .overlay(.white.opacity(0.08))

            WorkspaceActionButton(
                title: "Add new project",
                systemImage: "folder.badge.plus",
                action: chooseWorkspaceDirectory
            )

            WorkspaceActionButton(
                title: "Don't work in a project",
                systemImage: "folder.badge.xmark",
                action: clearWorkspace
            )
        }
        .padding(10)
        .frame(width: 270)
        .background(.black, in: .rect(cornerRadius: 16))
        .concentricRectangle(
            count: 2,
            spacing: 2,
            cornerRadius: 16,
            lineWidth: 0.5,
            colors: [
                OpenMacPalette.primaryAccent.opacity(0.16),
                OpenMacPalette.accentGlow.opacity(0.08),
            ],
            animate: false
        )
    }
}

#Preview("Workspace Picker View") {
    WorkspacePickerView(
        searchText: .constant(""),
        workspaceURLs: [
            URL(fileURLWithPath: "/Users/beng", isDirectory: true),
            URL(fileURLWithPath: "/Users/beng/Documents/iOS Projects/OpenMac", isDirectory: true),
        ],
        selectedWorkspaceURL: URL(fileURLWithPath: "/Users/beng/Documents/iOS Projects/OpenMac", isDirectory: true),
        selectWorkspace: { _ in },
        chooseWorkspaceDirectory: {},
        clearWorkspace: {}
    )
    .padding(24)
    .background(.black)
    .preferredColorScheme(.dark)
}
