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
        stepSymbol
            .font(.system(size: 17, weight: .semibold))
            .symbolRenderingMode(.monochrome)
            .foregroundStyle(OpenMacPalette.primaryAccent)
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
