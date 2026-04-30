//
//  OpenMacBackgroundTexture.swift
//  OpenMac
//
//  Created by Hermes on 30/04/26.
//

import SwiftUI

struct OpenMacBackgroundTexture: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    OpenMacPalette.background,
                    OpenMacPalette.surfacePrimary.opacity(0.92),
                    .black.opacity(0.96),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RadialGradient(
                colors: [
                    OpenMacPalette.primaryAccent.opacity(0.20),
                    OpenMacPalette.accentShadow.opacity(0.10),
                    .clear,
                ],
                center: .topTrailing,
                startRadius: 18,
                endRadius: 780
            )

            RadialGradient(
                colors: [
                    OpenMacPalette.surfaceSecondary.opacity(0.54),
                    OpenMacPalette.background.opacity(0.10),
                    .clear,
                ],
                center: .bottomLeading,
                startRadius: 80,
                endRadius: 760
            )
            .opacity(0.70)

            LinearGradient(
                colors: [
                    .black.opacity(0.16),
                    .clear,
                    .black.opacity(0.34),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

#Preview("Background Texture") {
    OpenMacBackgroundTexture()
        .frame(width: 980, height: 640)
        .preferredColorScheme(.dark)
}
