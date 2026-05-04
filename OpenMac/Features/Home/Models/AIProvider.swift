//
//  AIProvider.swift
//  OpenMac
//
//  Created by OpenMac on 04/05/26.
//

import Foundation

struct AIProvider: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let iconName: String
    let description: String
    let isDefault: Bool

    init(
        id: String,
        name: String,
        iconName: String = "cpu",
        description: String = "",
        isDefault: Bool = false
    ) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.description = description
        self.isDefault = isDefault
    }
}

// MARK: - Presets

extension AIProvider {
    static let allDefaults: [AIProvider] = [
        AIProvider(
            id: "local",
            name: "Local",
            iconName: "desktopcomputer",
            description: "Run models locally on your Mac",
            isDefault: true
        ),
        AIProvider(
            id: "openai",
            name: "OpenAI",
            iconName: "cloud",
            description: "GPT models via OpenAI API"
        ),
        AIProvider(
            id: "anthropic",
            name: "Anthropic",
            iconName: "cloud",
            description: "Claude models via Anthropic API"
        ),
    ]
}
