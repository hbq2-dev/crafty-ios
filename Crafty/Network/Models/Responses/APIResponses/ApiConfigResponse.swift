//
// Created for Crafty iOS by hbq2-dev
// ApiConfigResponse.swift
//
// Copyright (c) 2025 HBQ2
//

struct ApiConfigResponse: Codable {
    let privacyPolicyUrl: String
    let termsOfServiceUrl: String
    let supportedServerVersions: [String]

    enum CodingKeys: String, CodingKey {
        case privacyPolicyUrl
        case termsOfServiceUrl
        case supportedServerVersions
    }
}
