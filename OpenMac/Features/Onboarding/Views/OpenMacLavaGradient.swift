//
//  OpenMacLavaGradient.swift
//  OpenMac
//
//  Created by Hermes on 30/04/26.
//

import SwiftUI

struct OpenMacLavaGradient: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            TimelineView(.animation) { timeline in
                let time = Float(timeline.date.timeIntervalSinceReferenceDate.remainder(dividingBy: 80))

                Rectangle()
                    .fill(
                        ShaderLibrary.default.openMacLavaAtmosphere(
                            .float2(Float(size.width), Float(size.height)),
                            .float(time),
                            .color(.lavaPeach),
                            .color(.lavaCream),
                            .color(.lavaOrange),
                            .color(.lavaCoral),
                            .color(.lavaRed),
                            .color(.lavaBurntRed),
                            .color(.lavaDeep)
                        )
                    )
                    .drawingGroup(opaque: true, colorMode: .extendedLinear)
            }
        }
    }
}

private extension Color {
    static let lavaPeach = Color(hex: 0xF4B47D)
    static let lavaCream = Color(hex: 0xFFD6A2)
    static let lavaOrange = Color(hex: 0xF36F4B)
    static let lavaCoral = Color(hex: 0xE65B43)
    static let lavaRed = Color(hex: 0xC9252D)
    static let lavaBurntRed = Color(hex: 0x8F251F)
    static let lavaDeep = Color(hex: 0x43100B)

    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

#Preview("Lava Gradient") {
    OpenMacLavaGradient()
        .frame(width: 980, height: 430)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .preferredColorScheme(.dark)
}
