//
//  Item.swift
//  OpenMac
//
//  Created by Bambang Tri Rahmat Doni on 29/04/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
