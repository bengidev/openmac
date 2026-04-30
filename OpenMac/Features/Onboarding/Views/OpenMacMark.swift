//
//  OpenMacMark.swift
//  OpenMac
//
//  Created by Hermes on 30/04/26.
//

import SwiftUI

struct OpenMacMark: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(OpenMacPalette.surfacePrimary.opacity(0.72))
                .frame(width: 88, height: 88)
                .overlay {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(OpenMacPalette.primaryAccent.opacity(0.24), lineWidth: 1)
                }
                .shadow(color: OpenMacPalette.primaryAccent.opacity(0.18), radius: 24, x: 0, y: 10)

            Image("OpenMacLogo")
                .resizable()
                .interpolation(.high)
                .scaledToFit()
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(OpenMacPalette.textPrimary.opacity(0.14), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.24), radius: 14, x: 0, y: 8)
        }
        .accessibilityHidden(true)
    }
}

#Preview("Logo Mark") {
    OpenMacComponentPreviewContainer {
        OpenMacMark()
    }
}
