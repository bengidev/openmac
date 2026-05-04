//
//  WorkspaceView.swift
//  OpenMac
//
//  Created by Bambang Tri Rahmat Doni on 02/05/26.
//

import AppKit
import Darwin
import Foundation
import SwiftUI

struct WorkspaceView: View {
    static var defaultWorkspaceDirectoryURL: URL {
        if
            let passwordEntry = getpwuid(getuid()),
            let homeDirectory = passwordEntry.pointee.pw_dir,
            let homePath = String(validatingUTF8: homeDirectory),
            !homePath.isEmpty
        {
            return URL(fileURLWithPath: homePath, isDirectory: true)
        }

        let fallbackHomeURL = FileManager.default.homeDirectoryForCurrentUser
        if
            fallbackHomeURL.lastPathComponent == "Data",
            let containerRange = fallbackHomeURL.path.range(of: "/Library/Containers/")
        {
            let userHomePath = String(fallbackHomeURL.path[..<containerRange.lowerBound])
            return URL(fileURLWithPath: userHomePath, isDirectory: true)
        }

        return fallbackHomeURL
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
                + storedURLs.filter { !isDiscardedInitialWorkspace($0) }
                + [selectedWorkspaceURL].compactMap { $0 }.filter { !isDiscardedInitialWorkspace($0) }
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
        .popover(isPresented: $isWorkspacePickerPresented) {
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
        .onAppear {
            normalizeSelectedWorkspaceIfNeeded()
        }
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

    private func isDiscardedInitialWorkspace(_ workspaceURL: URL) -> Bool {
        let path = workspaceURL.standardizedFileURL.path
        return path == "/"
            || (workspaceURL.lastPathComponent == "Data" && path.contains("/Library/Containers/"))
    }

    private func normalizeSelectedWorkspaceIfNeeded() {
        if let selectedWorkspaceURL, isDiscardedInitialWorkspace(selectedWorkspaceURL) {
            selectedWorkspacePath = Self.defaultWorkspaceDirectoryURL.standardizedFileURL.path
        }

        let trackedURLs = trackedWorkspacePathsStorage
            .split(separator: "\n")
            .map { URL(fileURLWithPath: String($0)) }
            .filter { !isDiscardedInitialWorkspace($0) }

        let cleanedStorage = uniqueWorkspaceURLs(trackedURLs)
            .map(\.standardizedFileURL.path)
            .joined(separator: "\n")

        if cleanedStorage != trackedWorkspacePathsStorage {
            trackedWorkspacePathsStorage = cleanedStorage
        }
    }

    private func selectWorkspace(_ workspaceURL: URL) {
        let normalizedURL = isDiscardedInitialWorkspace(workspaceURL) ? Self.defaultWorkspaceDirectoryURL : workspaceURL
        let path = normalizedURL.standardizedFileURL.path
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
        .filter { !isDiscardedInitialWorkspace($0) }
        .map(\.standardizedFileURL.path)

        trackedWorkspacePathsStorage = uniquePaths.joined(separator: "\n")
    }

    private func clearWorkspace() {
        selectedWorkspacePath = ""
        workspaceSearchText = ""
        isWorkspacePickerPresented = false
    }

    @MainActor
    private func chooseWorkspaceDirectory() {
        let panel = NSOpenPanel()
        panel.title = "Choose Workspace"
        panel.prompt = "Choose"
        panel.message = "Select a folder to use as the current workspace."
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.directoryURL = selectedWorkspaceURL ?? Self.defaultWorkspaceDirectoryURL

        guard panel.runModal() == .OK, let workspaceURL = panel.url else { return }

        selectWorkspace(workspaceURL)
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
