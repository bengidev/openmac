//
//  OpenMacComponentPreviewContainer.swift
//  OpenMac
//
//  Created by Hermes on 30/04/26.
//

import SwiftUI

struct OpenMacComponentPreviewContainer<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(32)
            .background {
                OpenMacPalette.background
                    .ignoresSafeArea()
            }
            .preferredColorScheme(.dark)
    }
}
