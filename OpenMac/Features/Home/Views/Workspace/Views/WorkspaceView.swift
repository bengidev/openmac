//
//  WorkspaceView.swift
//  OpenMac
//
//  Created by Bambang Tri Rahmat Doni on 02/05/26.
//

import Foundation
import SwiftUI

struct WorkspaceView: View {
    private static var defaultWorkspaceDirectoryURL: URL {
        FileManager.default.homeDirectoryForCurrentUser
    }

    @AppStorage("home.selectedWorkspacePath") private var selectedWorkspacePath = WorkspaceView.defaultWorkspaceDirectoryURL.path

    @State private var isWorkspacePickerPresented = false
    @State private var workspaceSearchText = ""

    private var selectedWorkspaceURL: URL? {
        guard !selectedWorkspacePath.isEmpty else { return nil }
        return URL(fileURLWithPath: selectedWorkspacePath)
    }

    private var workingDirectoryName: String {
        guard let selectedWorkspaceURL else { return "No Project" }

        let name = selectedWorkspaceURL.lastPathComponent
        return name.isEmpty ? selectedWorkspaceURL.path : name
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
                workspaceURLs: [selectedWorkspaceURL].compactMap { $0 },
                selectedWorkspaceURL: selectedWorkspaceURL,
                selectWorkspace: selectWorkspace,
                chooseWorkspaceDirectory: chooseWorkspaceDirectory,
                clearWorkspace: clearWorkspace
            )
        }
        .accessibilityLabel("Working directory")
        .accessibilityValue(workingDirectoryName)
    }

    private func selectWorkspace(_ workspaceURL: URL) {
        selectedWorkspacePath = workspaceURL.standardizedFileURL.path
        workspaceSearchText = ""
        isWorkspacePickerPresented = false
    }

    private func clearWorkspace() {
        selectedWorkspacePath = ""
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
