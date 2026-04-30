//
//  OpenMacPalette.swift
//  OpenMac
//
//  Created by Hermes on 30/04/26.
//

import SwiftUI

/// Brand palette adapted from the reference Pin:
/// https://id.pinterest.com/pin/339388521938805724/
///
/// Backed by color sets in `OpenMac/Assets.xcassets` so the same palette can be
/// reused from Xcode's asset picker, SwiftUI, AppKit, Interface Builder, and previews.
enum OpenMacPalette {
    // MARK: - Source palette

    static let darkVoid = Color("OpenMacDarkVoid") // #151419
    static let liquidLava = Color("OpenMacLiquidLava") // #F56E0F
    static let gluonGrey = Color("OpenMacGluonGrey") // #1B1B1E
    static let slateGrey = Color("OpenMacSlateGrey") // #262626
    static let dustyGrey = Color("OpenMacDustyGrey") // #878787
    static let snow = Color("OpenMacSnow") // #FBFBFB

    // MARK: - Semantic tokens

    static let background = Color("OpenMacBackground")
    static let surfacePrimary = Color("OpenMacSurfacePrimary")
    static let surfaceSecondary = Color("OpenMacSurfaceSecondary")
    static let textPrimary = Color("OpenMacTextPrimary")
    static let textMuted = Color("OpenMacTextMuted")
    static let primaryAccent = Color("OpenMacPrimaryAccent")

    // MARK: - Derived atmospheric colors

    static let accentGlow = Color("OpenMacAccentGlow") // #FF801F
    static let accentShadow = Color("OpenMacAccentShadow") // #5C170D
    static let hairline = Color("OpenMacHairline") // #FBFBFB @ 10%
}
