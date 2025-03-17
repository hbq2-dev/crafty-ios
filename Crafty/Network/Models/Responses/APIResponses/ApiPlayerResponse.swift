//
//
// Created for Crafty iOS by hbq2dev
// ApiPlayerResponse.swift
//
//  Copyright © 2025 hbq2dev.
//

import Foundation

struct ApiPlayerResponse: Codable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    let name: String
    let status: String
    let lastSeen: String

    enum CodingKeys: String, CodingKey {
        case name
        case status
        case lastSeen = "last_seen"
    }
}
