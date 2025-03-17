//
//
// Created for Crafty iOS by hbq2dev
// ApiTokenResponse.swift
//
//  Copyright © 2025 hbq2dev.
//

import Foundation

struct ApiTokenResponse: Codable {
    let status: String
    let data: ApiTokenResponseData
}

struct ApiTokenResponseData: Codable {
    let token, userID: String

    enum CodingKeys: String, CodingKey {
        case token
        case userID = "user_id"
    }
}
