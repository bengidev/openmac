//
//  OpenMacApp.swift
//  OpenMac
//
//  Created by Bambang Tri Rahmat Doni on 29/04/26.
//

import SwiftUI
import SwiftData

@main
struct OpenMacApp: App {
    @State private var isShowingHome = false

    var body: some Scene {
        WindowGroup {
            Group {
                if isShowingHome {
                    HomeView()
                } else {
                    OnboardingView {
                        withAnimation(.easeInOut(duration: 0.28)) {
                            isShowingHome = true
                        }
                    }
                }
            }
        }
    }
}
