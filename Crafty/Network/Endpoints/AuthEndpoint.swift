//
// Created for Crafty iOS by hbq2-dev
// AuthEndpoint.swift
//
// Copyright (c) 2025 HBQ2
//

import Foundation

enum AuthEndpoint {
    case apiIndex
    case getToken(model: APILoginRequest)
    case getConfig
}

extension AuthEndpoint: EndPointType {
    var path: String {
        switch self {
        case .apiIndex:
            ""
        case .getToken:
            "/auth/login"
        case .getConfig:
            "/assets/config/crafty.json"
        }
    }

    var url: URL? {
        switch self {
        case .getConfig:
            let baseUrl = "https://spicyramen.dev"

            return URL(string: "\(baseUrl)\(path)")
        case .apiIndex, .getToken:
            let baseUrl = "https://\(UserDefaults.standard.string(forKey: CraftyConstants.serverUrl) ?? "")/api/v2"

            return URL(string: "\(baseUrl)\(path)")
        }
    }

    var method: HTTPMethods {
        switch self {
        case .apiIndex, .getConfig:
            .get
        case .getToken:
            .post
        }
    }

    var body: Encodable? {
        switch self {
        case .apiIndex, .getConfig:
            nil
        case let .getToken(model: model):
            model
        }
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }
}
