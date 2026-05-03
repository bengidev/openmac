//
//  OnboardingView.swift
//  OpenMac
//
//  Created by Hermes on 30/04/26.
//

import SwiftUI

struct OnboardingView: View {
    var onGetStarted: () -> Void = {}

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let horizontalPadding = max(15, min(25, size.width * 0.015))
            let verticalPadding = max(10, min(20, size.height * 0.10))
            let heroHeight = max(420, size.height - verticalPadding * 2 - 200)

            ZStack {
                OpenMacPalette.background
                    .ignoresSafeArea()

                OpenMacBackgroundTexture()
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    OpenMacHeroCard(onGetStarted: onGetStarted)
                        .frame(maxWidth: .infinity)
                        .frame(height: heroHeight)

                    HStack(spacing: 10) {
                        OnboardingStepCard(
                            symbolName: "hare.fill",
                            title: "Fast mode",
                            description: "Lower-latency turns for quick interactions"
                        )

                        OnboardingStepCard(
                            symbolName: "arrow.triangle.branch",
                            title: "Git from your phone",
                            description: "Commit, push, pull, and switch branches"
                        )

                        OnboardingStepCard(
                            symbolName: "lock.shield.fill",
                            title: "End-to-end encrypted",
                            description: "The relay never sees your prompts or code"
                        )
                        OnboardingStepCard(
                            symbolName: "waveform",
                            title: "Voice mode",
                            description: "Talk to Codex with speech-to-text"
                        )
                    }
                    .frame(height: 132)
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
            }
            .frame(width: size.width, height: size.height)
            .clipped()
        }
        .frame(minWidth: 920, minHeight: 640)
        .preferredColorScheme(.dark)
    }
}

#Preview("Onboarding") {
    OnboardingView()
        .frame(width: 1200, height: 760)
}
