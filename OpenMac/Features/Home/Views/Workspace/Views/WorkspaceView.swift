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
    @AppStorage("home.trackedWorkspacePaths") private var trackedWorkspacePathsStorage = ""

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

    private var trackedWorkspaceURLs: [URL] {
        let storedURLs = trackedWorkspacePathsStorage
            .split(separator: "\n")
            .map { URL(fileURLWithPath: String($0)) }

        return uniqueWorkspaceURLs(
            [Self.defaultWorkspaceDirectoryURL]
                + storedURLs
                + [selectedWorkspaceURL].compactMap { $0 }
        )
    }

    private var filteredWorkspaceURLs: [URL] {
        let query = workspaceSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return trackedWorkspaceURLs }

        return trackedWorkspaceURLs.filter { workspaceURL in
            workspaceURL.lastPathComponent.localizedCaseInsensitiveContains(query)
                || workspaceURL.path.localizedCaseInsensitiveContains(query)
        }
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
                workspaceURLs: filteredWorkspaceURLs,
                selectedWorkspaceURL: selectedWorkspaceURL,
                selectWorkspace: selectWorkspace,
                chooseWorkspaceDirectory: chooseWorkspaceDirectory,
                clearWorkspace: clearWorkspace
            )
        }
        .accessibilityLabel("Working directory")
        .accessibilityValue(workingDirectoryName)
    }

    private func uniqueWorkspaceURLs(_ urls: [URL]) -> [URL] {
        var seenPaths = Set<String>()

        return urls.filter { url in
            let path = url.standardizedFileURL.path
            guard !seenPaths.contains(path) else { return false }

            seenPaths.insert(path)
            return true
        }
    }

    private func selectWorkspace(_ workspaceURL: URL) {
        let path = workspaceURL.standardizedFileURL.path
        selectedWorkspacePath = path
        trackWorkspacePath(path)
        workspaceSearchText = ""
        isWorkspacePickerPresented = false
    }

    private func trackWorkspacePath(_ path: String) {
        let trackedPaths = trackedWorkspacePathsStorage
            .split(separator: "\n")
            .map(String.init)

        let uniquePaths = uniqueWorkspaceURLs(
            trackedPaths.map { URL(fileURLWithPath: $0) } + [URL(fileURLWithPath: path)]
        )
        .map(\.standardizedFileURL.path)

        trackedWorkspacePathsStorage = uniquePaths.joined(separator: "\n")
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
