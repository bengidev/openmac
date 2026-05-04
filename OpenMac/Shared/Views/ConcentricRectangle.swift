//
//  ConcentricRectangle.swift
//  OpenMac
//
//  Created by OpenMac on 04/05/26.
//

import SwiftUI

// MARK: - View Extension

extension View {
    /// Applies a concentric rectangle border effect — multiple nested rounded rectangles
    /// that create layered depth, similar to a frame-within-frame aesthetic.
    func concentricRectangle(
        count: Int = 3,
        spacing: CGFloat = 4,
        cornerRadius: CGFloat = 20,
        lineWidth: CGFloat = 1,
        colors: [Color] = [OpenMacPalette.primaryAccent, OpenMacPalette.accentGlow, OpenMacPalette.liquidLava],
        animate: Bool = true,
        isEnabled: Bool = true
    ) -> some View {
        modifier(
            ConcentricRectangleEffect(
                count: count,
                spacing: spacing,
                cornerRadius: cornerRadius,
                lineWidth: lineWidth,
                colors: colors,
                animate: animate,
                isEnabled: isEnabled
            )
        )
    }
}

// MARK: - Effect Modifier

struct ConcentricRectangleEffect: ViewModifier {
    let count: Int
    let spacing: CGFloat
    let cornerRadius: CGFloat
    let lineWidth: CGFloat
    let colors: [Color]
    let animate: Bool
    let isEnabled: Bool

    @State private var pulsePhase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .center) {
                if isEnabled {
                    concentricRectangles
                }
            }
    }

    @ViewBuilder
    private var concentricRectangles: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let maxInset = CGFloat(count - 1) * spacing

            ZStack {
                ForEach(0..<count, id: \.self) { index in
                    let inset = CGFloat(index) * spacing
                    let normalized = Double(index) / Double(max(count - 1, 1))
                    let color = colors[index % colors.count]
                    let opacity = 1.0 - (normalized * 0.7)
                    let scale = animate
                        ? 1.0 + (sin(pulsePhase + Double(index) * 0.6) * 0.008)
                        : 1.0

                    RoundedRectangle(cornerRadius: max(cornerRadius - inset, 0), style: .continuous)
                        .stroke(color.opacity(opacity), lineWidth: lineWidth)
                        .frame(
                            width: max(size.width - inset * 2, 0) * scale,
                            height: max(size.height - inset * 2, 0) * scale
                        )
                        .position(x: size.width / 2, y: size.height / 2)
                }
            }
            .onAppear {
                guard animate else { return }
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    pulsePhase = .pi * 2
                }
            }
        }
    }
}

// MARK: - Background Variant

extension View {
    /// Applies concentric rectangles as a background decoration behind the content.
    func concentricRectangleBackground(
        count: Int = 4,
        spacing: CGFloat = 12,
        cornerRadius: CGFloat = 24,
        lineWidth: CGFloat = 0.5,
        colors: [Color] = [OpenMacPalette.primaryAccent.opacity(0.14), OpenMacPalette.accentGlow.opacity(0.10), OpenMacPalette.liquidLava.opacity(0.08)],
        animate: Bool = false,
        isEnabled: Bool = true
    ) -> some View {
        modifier(
            ConcentricRectangleBackgroundEffect(
                count: count,
                spacing: spacing,
                cornerRadius: cornerRadius,
                lineWidth: lineWidth,
                colors: colors,
                animate: animate,
                isEnabled: isEnabled
            )
        )
    }
}

struct ConcentricRectangleBackgroundEffect: ViewModifier {
    let count: Int
    let spacing: CGFloat
    let cornerRadius: CGFloat
    let lineWidth: CGFloat
    let colors: [Color]
    let animate: Bool
    let isEnabled: Bool

    @State private var pulsePhase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .background {
                if isEnabled {
                    concentricRectangles
                }
            }
    }

    @ViewBuilder
    private var concentricRectangles: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let maxInset = CGFloat(count - 1) * spacing

            ZStack {
                ForEach(0..<count, id: \.self) { index in
                    let inset = CGFloat(index) * spacing
                    let normalized = Double(index) / Double(max(count - 1, 1))
                    let color = colors[index % colors.count]
                    let opacity = 1.0 - (normalized * 0.5)
                    let scale = animate
                        ? 1.0 + (sin(pulsePhase + Double(index) * 0.4) * 0.006)
                        : 1.0

                    RoundedRectangle(cornerRadius: max(cornerRadius + inset, 0), style: .continuous)
                        .stroke(color.opacity(opacity), lineWidth: lineWidth)
                        .frame(
                            width: (size.width + inset * 2) * scale,
                            height: (size.height + inset * 2) * scale
                        )
                        .position(x: size.width / 2, y: size.height / 2)
                }
            }
            .onAppear {
                guard animate else { return }
                withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                    pulsePhase = .pi * 2
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Concentric Rectangle") {
    VStack(spacing: 24) {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(OpenMacPalette.surfacePrimary)
            .frame(width: 200, height: 120)
            .concentricRectangle(
                count: 4,
                spacing: 6,
                cornerRadius: 20,
                colors: [OpenMacPalette.primaryAccent, OpenMacPalette.accentGlow, OpenMacPalette.liquidLava, OpenMacPalette.accentShadow]
            )

        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(OpenMacPalette.surfaceSecondary)
            .frame(width: 200, height: 120)
            .concentricRectangleBackground(
                count: 5,
                spacing: 8,
                cornerRadius: 16,
                colors: [
                    OpenMacPalette.primaryAccent.opacity(0.20),
                    OpenMacPalette.accentGlow.opacity(0.14),
                    OpenMacPalette.liquidLava.opacity(0.10),
                ],
                animate: true
            )
    }
    .padding(40)
    .background(OpenMacPalette.background)
    .preferredColorScheme(.dark)
}
