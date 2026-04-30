//
//  OpenMacLavaGradient.swift
//  OpenMac
//
//  Created by Hermes on 30/04/26.
//

import SwiftUI

struct OpenMacLavaGradient: View {
    @State private var isAlive = false

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ZStack {
                LinearGradient(
                    colors: [
                        Color.lavaPeach,
                        Color.lavaCoral,
                        Color.lavaRed,
                        Color.lavaDeep,
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                lavaBlob(
                    color: .lavaPeach,
                    opacity: 0.72,
                    width: size.width * 0.70,
                    height: size.height * 0.96,
                    blur: 86,
                    x: isAlive ? -size.width * 0.30 : -size.width * 0.36,
                    y: isAlive ? -size.height * 0.24 : -size.height * 0.30,
                    scale: isAlive ? 1.06 : 0.96,
                    blendMode: .screen
                )

                lavaBlob(
                    color: .lavaCoral,
                    opacity: 0.62,
                    width: size.width * 0.54,
                    height: size.height * 0.70,
                    blur: 78,
                    x: isAlive ? -size.width * 0.33 : -size.width * 0.24,
                    y: isAlive ? size.height * 0.16 : size.height * 0.24,
                    scale: isAlive ? 1.07 : 0.98,
                    blendMode: .overlay
                )

                lavaBlob(
                    color: .lavaRed,
                    opacity: 0.86,
                    width: size.width * 0.72,
                    height: size.height * 0.72,
                    blur: 82,
                    x: isAlive ? size.width * 0.31 : size.width * 0.25,
                    y: isAlive ? -size.height * 0.24 : -size.height * 0.17,
                    scale: isAlive ? 1.03 : 0.95,
                    blendMode: .overlay
                )

                lavaBlob(
                    color: .lavaOrange,
                    opacity: 0.78,
                    width: size.width * 0.82,
                    height: size.height * 0.64,
                    blur: 96,
                    x: isAlive ? -size.width * 0.05 : size.width * 0.03,
                    y: isAlive ? size.height * 0.22 : size.height * 0.16,
                    scale: isAlive ? 1.10 : 0.98,
                    blendMode: .screen
                )

                lavaBlob(
                    color: .lavaCream,
                    opacity: isAlive ? 0.74 : 0.54,
                    width: size.width * 0.54,
                    height: size.height * 0.40,
                    blur: 84,
                    x: isAlive ? size.width * 0.19 : size.width * 0.26,
                    y: isAlive ? size.height * 0.07 : size.height * 0.15,
                    scale: isAlive ? 1.08 : 0.94,
                    blendMode: .plusLighter
                )

                lavaBlob(
                    color: .lavaDeep,
                    opacity: 0.46,
                    width: size.width * 0.74,
                    height: size.height * 0.48,
                    blur: 72,
                    x: isAlive ? size.width * 0.20 : size.width * 0.10,
                    y: isAlive ? size.height * 0.38 : size.height * 0.31,
                    scale: isAlive ? 1.10 : 0.96,
                    blendMode: .multiply
                )

                Capsule()
                    .fill(Color.lavaDeep.opacity(isAlive ? 0.58 : 0.42))
                    .frame(width: size.width * 0.88, height: size.height * 0.25)
                    .rotationEffect(.degrees(isAlive ? 15 : 10))
                    .blur(radius: 58)
                    .offset(x: isAlive ? -size.width * 0.24 : -size.width * 0.34, y: size.height * 0.21)
                    .blendMode(.multiply)

                Capsule()
                    .fill(Color.lavaCream.opacity(isAlive ? 0.15 : 0.08))
                    .frame(width: size.width * 0.82, height: 34)
                    .rotationEffect(.degrees(-18))
                    .blur(radius: 28)
                    .offset(x: isAlive ? size.width * 0.18 : -size.width * 0.08, y: isAlive ? -size.height * 0.18 : -size.height * 0.06)
                    .blendMode(.plusLighter)

                LavaSparkles(isAlive: isAlive)
                    .opacity(0.54)
                    .blendMode(.screen)

                LavaGrain()
                    .opacity(0.105)
                    .blendMode(.overlay)

                LinearGradient(
                    colors: [
                        .black.opacity(0.26),
                        .clear,
                        .black.opacity(0.18),
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .blendMode(.multiply)

                RadialGradient(
                    colors: [
                        .clear,
                        Color.lavaDeep.opacity(0.18),
                        .black.opacity(0.46),
                    ],
                    center: .center,
                    startRadius: min(size.width, size.height) * 0.30,
                    endRadius: max(size.width, size.height) * 0.78
                )
                .blendMode(.multiply)

                LinearGradient(
                    colors: [
                        .white.opacity(0.08),
                        .clear,
                        .black.opacity(0.18),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .blendMode(.softLight)
            }
            .animation(.easeInOut(duration: 11).repeatForever(autoreverses: true), value: isAlive)
            .onAppear {
                isAlive = true
            }
        }
    }

    private func lavaBlob(
        color: Color,
        opacity: Double,
        width: CGFloat,
        height: CGFloat,
        blur: CGFloat,
        x: CGFloat,
        y: CGFloat,
        scale: CGFloat,
        blendMode: BlendMode
    ) -> some View {
        Ellipse()
            .fill(color.opacity(opacity))
            .frame(width: width, height: height)
            .scaleEffect(scale)
            .blur(radius: blur)
            .offset(x: x, y: y)
            .blendMode(blendMode)
    }
}

private struct LavaSparkles: View {
    let isAlive: Bool

    var body: some View {
        Canvas { context, size in
            for index in 0..<26 {
                let x = size.width * Self.unit(index, salt: 11)
                let drift = isAlive ? size.height * 0.035 : -size.height * 0.018
                let y = size.height * Self.unit(index, salt: 47) + drift
                let radius = CGFloat(0.8 + Self.unit(index, salt: 83) * 2.1)
                let alpha = 0.10 + Self.unit(index, salt: 109) * 0.18

                let rect = CGRect(x: x, y: y, width: radius, height: radius)
                context.fill(
                    Path(ellipseIn: rect),
                    with: .color(Color.lavaCream.opacity(alpha))
                )
            }
        }
        .blur(radius: 0.45)
        .animation(.easeInOut(duration: 14).repeatForever(autoreverses: true), value: isAlive)
    }

    private static func unit(_ index: Int, salt: Int) -> CGFloat {
        let value = (index * 73 + salt * 97) % 997
        return CGFloat(value) / 997
    }
}

private struct LavaGrain: View {
    var body: some View {
        Canvas { context, size in
            for index in 0..<150 {
                let x = size.width * Self.unit(index, salt: 3)
                let y = size.height * Self.unit(index, salt: 61)
                let side = CGFloat(0.8 + Self.unit(index, salt: 29) * 1.5)
                let alpha = 0.11 + Self.unit(index, salt: 107) * 0.18

                let rect = CGRect(x: x, y: y, width: side, height: side)
                context.fill(
                    Path(ellipseIn: rect),
                    with: .color(.white.opacity(alpha))
                )
            }
        }
    }

    private static func unit(_ index: Int, salt: Int) -> CGFloat {
        let value = (index * 151 + salt * 43) % 1009
        return CGFloat(value) / 1009
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
