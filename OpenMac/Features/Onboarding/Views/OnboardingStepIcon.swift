//
//  OnboardingStepIcon.swift
//  OpenMac
//
//  Created by Hermes on 03/05/26.
//

import SwiftUI

struct OnboardingStepIcon: View {
    let symbolName: String

    init(symbolName: String = "apple.intelligence") {
        self.symbolName = symbolName
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(OpenMacPalette.surfacePrimary.opacity(0.76))
                .frame(width: 34, height: 34)
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(OpenMacPalette.primaryAccent.opacity(0.20), lineWidth: 1)
                }

            stepSymbol
                .font(.system(size: 17, weight: .semibold))
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(OpenMacPalette.primaryAccent)
        }
        .shadow(color: OpenMacPalette.primaryAccent.opacity(0.16), radius: 10, x: 0, y: 4)
        .accessibilityHidden(true)
    }

    @ViewBuilder
    private var stepSymbol: some View {
        if #available(macOS 15.0, *) {
            Image(systemName: symbolName)
        } else {
            Image(systemName: "sparkles")
        }
    }
}
