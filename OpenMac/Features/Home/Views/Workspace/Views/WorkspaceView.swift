//
//  WorkspaceView.swift
//  OpenMac
//
//  Created by Bambang Tri Rahmat Doni on 02/05/26.
//

import Foundation
import SwiftUI

struct WorkspaceView: View {
    @State private var isWorkspacePickerPresented = false
    @State private var workspaceSearchText = ""

    private var selectedWorkspaceURL: URL? {
        nil
    }

    private var workingDirectoryName: String {
        "No Project"
    }

    var body: some View {
        Button {
            isWorkspacePickerPresented.toggle()
        } label: {
            WorkspaceSelectorLabel(
                workingDirectoryName: workingDirectoryName,
                isWorkspaceSelected: selectedWorkspaceURL != nil
            )
        }
        .buttonStyle(.plain)
        .popover(isPresented: $isWorkspacePickerPresented, arrowEdge: .bottom) {
            WorkspacePickerView(
                searchText: $workspaceSearchText,
                workspaceURLs: [],
                selectedWorkspaceURL: selectedWorkspaceURL,
                selectWorkspace: selectWorkspace,
                chooseWorkspaceDirectory: chooseWorkspaceDirectory,
                clearWorkspace: clearWorkspace
            )
        }
        .accessibilityLabel("Working directory")
        .accessibilityValue(workingDirectoryName)
    }

    private func selectWorkspace(_: URL) {
        workspaceSearchText = ""
        isWorkspacePickerPresented = false
    }

    private func clearWorkspace() {
        workspaceSearchText = ""
        isWorkspacePickerPresented = false
    }

    private func chooseWorkspaceDirectory() {
        workspaceSearchText = ""
        isWorkspacePickerPresented = false
    }
}

#Preview("Workspace View") {
    VStack(alignment: .leading) {
        WorkspaceView()
    }
    .padding(24)
    .frame(width: 360)
    .background(.black)
    .preferredColorScheme(.dark)
}
