//
//  OnboardingView.swift
//  OpenMac
//
//  Created by Hermes on 30/04/26.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let horizontalPadding = max(15, min(25, size.width * 0.015))
            let verticalPadding = max(10, min(20, size.height * 0.10))
            let heroHeight = max(460, size.height - verticalPadding * 2 - 200)

            ZStack {
                OpenMacPalette.background
                    .ignoresSafeArea()

                OpenMacBackgroundTexture()
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    OpenMacHeroCard()
                        .frame(maxWidth: .infinity)
                        .frame(height: heroHeight)

                    HStack(spacing: 16) {
                        OpenMacStepCard(
                            number: "01",
                            title: "Connect your content",
                            description: "Bring in notes, files, links, and daily context so OpenMac can understand your workspace."
                        )

                        OpenMacStepCard(
                            number: "02",
                            title: "Train and customize",
                            description: "Shape tone, shortcuts, and preferences into a digital mind that works like you do."
                        )

                        OpenMacStepCard(
                            number: "03",
                            title: "Use it everywhere",
                            description: "Start from your Mac, then extend the same memory and workflow across every surface."
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
