//
//  HomeView.swift
//  OpenMac
//
//  Created by Bambang Tri Rahmat Doni on 02/05/26.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @AppStorage("home.selectedWorkspacePath") private var selectedWorkspacePath = WorkspaceView.defaultWorkspaceDirectoryURL.path
    @AppStorage("home.selectedProviderID") private var selectedProviderID = AIProvider.allDefaults[0].id

    @State private var inputText = ""

    private var hasInputText: Bool {
        inputText.contains { !$0.isWhitespace }
    }

    private var selectedProvider: AIProvider {
        AIProvider.allDefaults.first { $0.id == selectedProviderID } ?? .allDefaults[0]
    }

    private var selectedWorkspaceDirectoryName: String {
        guard !selectedWorkspacePath.isEmpty else { return "No Project" }

        let workspaceURL = URL(fileURLWithPath: selectedWorkspacePath)
        let name = workspaceURL.lastPathComponent
        return name.isEmpty ? workspaceURL.path : name
    }

    var body: some View {
        VStack {
            (
                Text("What should we work on in ")
                    .font(.system(size: 34, weight: .regular, design: .default))
                    + Text(selectedWorkspaceDirectoryName)
                    .font(.system(size: 34, weight: .regular, design: .monospaced))
                    .italic()
                    + Text("?")
                    .font(.system(size: 34, weight: .regular, design: .serif))
            )
            .tracking(1.4)
            .foregroundStyle(Color.white.opacity(0.86))
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.75)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 28)

            VStack(alignment: .leading, spacing: 22) {
                ZStack(alignment: .topLeading) {
                    if inputText.isEmpty {
                        Text("Ask Anything...")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 14)
                            .allowsHitTesting(false)
                    }

                    TextEditor(text: $inputText)
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .scrollContentBackground(.hidden)
                        .scrollIndicators(.hidden)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                }
                .frame(minHeight: 60, maxHeight: 160, alignment: .topLeading)
                .background(.black.opacity(0.24), in: .rect(cornerRadius: 16))

                HStack(spacing: 12) {
                    AIProviderPickerView(
                        selectedProvider: Binding(
                            get: { selectedProvider },
                            set: { newProvider in selectedProviderID = newProvider.id }
                        ),
                        providers: AIProvider.allDefaults
                    )

                    WorkspaceView()

                    Spacer(minLength: 0)

                    Group {
                        Button {
                        } label: {
                            Image(systemName: "plus")
                        }

                        Button {
                        } label: {
                            Image(systemName: "cloud")
                        }

                        Button {
                        } label: {
                            Image(systemName: "mic")
                        }

                        Button {
                        } label: {
                            Image(systemName: "arrow.up")
                        }
                        .frame(width: 35, height: 35)
                        .borderBeam(
                            border: .primary,
                            hideFadeBorder: false,
                            beam: [
                                OpenMacPalette.accentShadow,
                                OpenMacPalette.primaryAccent,
                                OpenMacPalette.accentGlow,
                                OpenMacPalette.liquidLava,
                                OpenMacPalette.accentShadow,
                            ],
                            beamBlur: 15,
                            cornerRadius: 20,
                            isEnabled: hasInputText
                        )
                        .animation(.easeInOut(duration: 0.18), value: hasInputText)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 10)
                }
            }
            .padding(18)
            .background(.gray.opacity(0.1), in: .rect(cornerRadius: 24))
            .concentricRectangle(
                count: 3,
                spacing: 3,
                cornerRadius: 24,
                lineWidth: 0.6,
                colors: [
                    OpenMacPalette.primaryAccent.opacity(0.20),
                    OpenMacPalette.accentGlow.opacity(0.12),
                    OpenMacPalette.liquidLava.opacity(0.08),
                ],
                animate: false
            )
            .borderBeam(
                border: .primary,
                hideFadeBorder: false,
                beam: [
                    OpenMacPalette.accentShadow,
                    OpenMacPalette.primaryAccent,
                    OpenMacPalette.accentGlow,
                    OpenMacPalette.liquidLava,
                    OpenMacPalette.accentShadow,
                ],
                beamBlur: 15,
                cornerRadius: 20,
                isEnabled: !hasInputText
            )
            .animation(.easeInOut(duration: 0.18), value: hasInputText)
        }
        .padding()
        .frame(minWidth: 920, minHeight: 640)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    HomeView()
}
