//
//
// Created for Crafty iOS by hbq2dev
// AuthEndpoint.swift
//
//  Copyright © 2025 hbq2dev.
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
            return ""
        case .getToken:
            return "/auth/login"
        }
    }

    var url: URL? {
        let baseUrl = "https://\(UserDefaults.standard.string(forKey: CraftyConstants.serverUrl) ?? "")/api/v2"

        return URL(string: "\(baseUrl)\(path)")
    }

    var method: HTTPMethods {
        switch self {
        case .apiIndex:
            return .get
        case .getToken:
            return .post
        }
    }

    var body: Encodable? {
        switch self {
        case .apiIndex:
            return nil
        case let .getToken(model: model):
            return model
        }
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }
}
