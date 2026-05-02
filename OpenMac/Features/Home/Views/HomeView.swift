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

                    TextEditor(text: $inputText)
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .scrollContentBackground(.hidden)
                        .scrollIndicators(.hidden)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                }
                .frame(minHeight: 60, maxHeight: 160, alignment: .topLeading)
                .background(.black.opacity(0.24), in: .rect(cornerRadius: 16))

                HStack(spacing: 12) {
                    Button {
                    } label: {
                        Text("Name/Model Name")
                            .font(.caption)
                            .foregroundStyle(Color.primary.opacity(0.82))
                            .padding(.vertical, 9)
                            .padding(.horizontal, 16)
                            .background(.white.opacity(0.08), in: .capsule)
                    }
                    .buttonStyle(.plain)

                    Spacer(minLength: 0)

                    Group {
                        Button {
                        } label: {
                            Image(systemName: "plus")
                        }

                        Button {
                        } label: {
                            Image(systemName: "cloud")
                        }

                        Button {
                        } label: {
                            Image(systemName: "mic")
                        }

                        Button {
                        } label: {
                            Image(systemName: "arrow.up")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
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
