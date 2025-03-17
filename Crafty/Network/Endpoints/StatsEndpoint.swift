//
//
// Created for Crafty iOS by hbq2dev
// StatsEndpoint.swift
//
//  Copyright © 2025 hbq2dev.
//

import Foundation

enum StatsEndpoint {
    case getStats
}

extension StatsEndpoint: EndPointType {
    var path: String {
        switch self {
        case .getStats:
            return "/crafty/stats"
        }
    }

    var url: URL? {
        let baseUrl = "https://\(UserDefaults.standard.string(forKey: CraftyConstants.serverUrl) ?? "")\(CraftyConstants.apiV2Suffix)"

        return URL(string: "\(baseUrl)\(path)")
    }

    var method: HTTPMethods {
        switch self {
        case .getStats:
            return .get
        }
    }

    var body: Encodable? {
        switch self {
        case .getStats:
            return nil
        }
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }
}
