//
// Created for Crafty iOS by hbq2-dev
// CraftyConstants.swift
//
// Copyright (c) 2025 HBQ2
//

import Foundation

enum CraftyConstants {
    static let serverUrl = "serverUrl"
    static let token = "token"
    static let headerAuthorization = "Authorization"
    static let headerBearer = "Bearer"
    static let headerCookie = "Cookie"

    static let privacyPolicyUrl = "privacyPolicyUrl"
    static let termsOfServiceUrl = "termsOfServiceUrl"

    static let apiV2Suffix = "/api/v2"

    static let serverTypes = ["vanilla", "paper", "fabric", "folia", "forge-installer", "purpur"]
    static let serverVersions = ["1.21.4", "1.21.3", "1.21.2", "1.21.1", "1.21", "1.20.6"]

    static func noCommaFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = false
        return formatter
    }
}
