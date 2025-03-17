//
//
// Created for Crafty iOS by hbq2dev
// ApiIndexResponse.swift
//
//  Copyright © 2025 hbq2dev.
//

struct ApiIndexResponse: Codable, Hashable {
    let status: String
    let data: ApiIndexResponseData
}

struct ApiIndexResponseData: Codable, Hashable {
    let version, message: String
}
