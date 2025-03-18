//
// Created for Crafty iOS by hbq2-dev
// ApiPlayerResponse.swift
//
// Copyright (c) 2025 HBQ2
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
