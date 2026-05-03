//
//  OnboardingStepCard.swift
//  OpenMac
//
//  Created by Hermes on 30/04/26.
//

import SwiftUI

struct OnboardingStepCard: View {
    let symbolName: String
    let title: String
    let description: String

    init(
        symbolName: String = "apple.intelligence",
        title: String,
        description: String
    ) {
        self.symbolName = symbolName
        self.title = title
        self.description = description
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 8) {
                OnboardingStepIcon(symbolName: symbolName)

                Text(title)
                    .font(.system(size: 20, weight: .regular, design: .serif))
                    .foregroundStyle(OpenMacPalette.textPrimary.opacity(0.96))
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)
            }

            Text(description)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(OpenMacPalette.textPrimary.opacity(0.62))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(22)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            OpenMacPalette.surfacePrimary,
                            OpenMacPalette.surfaceSecondary.opacity(0.88),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(OpenMacPalette.hairline.opacity(0.58), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.20), radius: 16, x: 0, y: 10)
    }
}

#Preview("Onboarding Step Card") {
    OpenMacComponentPreviewContainer {
        OnboardingStepCard(
            title: "Connect your content",
            description: "Bring in notes, files, links, and daily context so OpenMac can understand your workspace."
        )
        .frame(width: 320, height: 138)
    }
}
