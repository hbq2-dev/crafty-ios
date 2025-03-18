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
}

extension AuthEndpoint: EndPointType {
    var path: String {
        switch self {
        case .apiIndex:
            ""
        case .getToken:
            "/auth/login"
        }
    }

    var url: URL? {
        let baseUrl = "https://\(UserDefaults.standard.string(forKey: CraftyConstants.serverUrl) ?? "")/api/v2"

        return URL(string: "\(baseUrl)\(path)")
    }

    var method: HTTPMethods {
        switch self {
        case .apiIndex:
            .get
        case .getToken:
            .post
        }
    }

    var body: Encodable? {
        switch self {
        case .apiIndex:
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
