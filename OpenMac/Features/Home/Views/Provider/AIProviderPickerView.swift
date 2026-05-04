//
//  AIProviderPickerView.swift
//  OpenMac
//
//  Created by OpenMac on 04/05/26.
//

import SwiftUI

struct AIProviderPickerView: View {
    @Binding var selectedProvider: AIProvider
    let providers: [AIProvider]

    @State private var isMenuPresented = false

    private var metaLabelColor: Color {
        Color.primary.opacity(0.82)
    }

    private var metaTextFont: Font {
        .caption
    }

    private var metaSymbolFont: Font {
        .system(size: 11, weight: .regular)
    }

    private var metaChevronFont: Font {
        .system(size: 9, weight: .regular)
    }

    var body: some View {
        Menu {
            Section("Provider") {
                ForEach(providers) { provider in
                    Button {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            selectedProvider = provider
                        }
                    } label: {
                        HStack(spacing: 8) {
                            if selectedProvider.id == provider.id {
                                Image(systemName: "checkmark")
                            }
                            Image(systemName: provider.iconName)
                            Text(provider.name)
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: selectedProvider.iconName)
                    .font(metaSymbolFont)

                Text(selectedProvider.name)
                    .font(metaTextFont)
                    .fontWeight(.regular)
                    .lineLimit(1)

                Image(systemName: "chevron.down")
                    .font(metaChevronFont)
            }
            .padding(.vertical, 9)
            .padding(.horizontal, 16)
            .foregroundStyle(metaLabelColor)
            .background(.white.opacity(0.08), in: .capsule)
            .concentricRectangle(
                count: 2,
                spacing: 1.5,
                cornerRadius: 20,
                lineWidth: 0.5,
                colors: [
                    OpenMacPalette.primaryAccent.opacity(0.14),
                    OpenMacPalette.accentGlow.opacity(0.08),
                ],
                animate: false
            )
            .contentShape(Rectangle())
        }
        .menuStyle(.button)
        .buttonStyle(.plain)
        .fixedSize(horizontal: true, vertical: false)
    }
}

#Preview {
    AIProviderPickerView(
        selectedProvider: .constant(AIProvider.allDefaults[0]),
        providers: AIProvider.allDefaults
    )
    .padding()
    .preferredColorScheme(.dark)
}
