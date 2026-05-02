//
//  HomeView.swift
//  OpenMac
//
//  Created by Bambang Tri Rahmat Doni on 02/05/26.
//

import SwiftUI

struct HomeView: View {
    @State private var inputText = ""

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 22) {
                ZStack(alignment: .topLeading) {
                    if inputText.isEmpty {
                        Text("Ask Anything...")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 14)
                            .allowsHitTesting(false)
                    }
                }
                .frame(minHeight: 60, maxHeight: 160, alignment: .topLeading)
                .background(.black.opacity(0.24), in: .rect(cornerRadius: 16))

                HStack(spacing: 12) {
                    Spacer(minLength: 0)
                }
            }
            .padding(18)
            .background(.gray.opacity(0.1), in: .rect(cornerRadius: 24))
        }
        .padding()
        .frame(minWidth: 920, minHeight: 640)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    HomeView()
}
