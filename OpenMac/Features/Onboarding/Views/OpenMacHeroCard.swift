//
//  OpenMacHeroCard.swift
//  OpenMac
//
//  Created by Hermes on 30/04/26.
//

import SwiftUI

struct OpenMacHeroCard: View {
    var onGetStarted: () -> Void = {}

    var body: some View {
        ZStack {
            OpenMacLavaGradient()

            VStack(spacing: 0) {
                Text("OPENMAC")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .tracking(3.2)
                    .foregroundStyle(OpenMacPalette.primaryAccent)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(OpenMacPalette.surfacePrimary.opacity(0.74))
                    .clipShape(Capsule())
                    .overlay {
                        Capsule()
                            .stroke(OpenMacPalette.primaryAccent.opacity(0.28), lineWidth: 1)
                    }
                    .padding(.bottom, 22)

                OpenMacMark()
                    .padding(.bottom, 28)

                Text("Create your Digital Mind")
                    .font(.system(size: 58, weight: .regular, design: .serif))
                    .foregroundStyle(OpenMacPalette.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)
                    .shadow(color: .black.opacity(0.28), radius: 20, x: 0, y: 12)

                Text("Build the Digital Version of your Mac to scale\nyour expertise & availability, infinitely")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(OpenMacPalette.textPrimary.opacity(0.68))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.top, 22)

                Button(action: onGetStarted) {
                    Text("Get Started")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(OpenMacPalette.background)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(OpenMacPalette.primaryAccent)
                        .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 11, style: .continuous)
                                .stroke(OpenMacPalette.accentGlow.opacity(0.42), lineWidth: 1)
                        }
                        .shadow(color: OpenMacPalette.primaryAccent.opacity(0.28), radius: 18, x: 0, y: 9)
                }
                .buttonStyle(.plain)
                .padding(.top, 28)
                .accessibilityLabel("Get Started")
            }
            .padding(.horizontal, 40)
        }
        .background(OpenMacPalette.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            OpenMacPalette.textPrimary.opacity(0.14),
                            OpenMacPalette.primaryAccent.opacity(0.38),
                            OpenMacPalette.surfaceSecondary.opacity(0.48),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .shadow(color: .black.opacity(0.36), radius: 30, x: 0, y: 20)
        .accessibilityElement(children: .contain)
    }
}

#Preview("Hero Card") {
    OpenMacComponentPreviewContainer {
        OpenMacHeroCard()
            .frame(width: 980, height: 430)
    }
}
