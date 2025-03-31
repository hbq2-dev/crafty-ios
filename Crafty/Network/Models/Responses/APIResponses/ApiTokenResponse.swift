//
// Created for Crafty iOS by hbq2-dev
// ApiTokenResponse.swift
//
// Copyright (c) 2025 HBQ2
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
