//
// Created for Crafty iOS by hbq2-dev
// StatsEndpoint.swift
//
// Copyright (c) 2025 HBQ2
//

import Foundation

enum StatsEndpoint {
    case getStats
}

extension StatsEndpoint: EndPointType {
    var path: String {
        switch self {
        case .getStats:
            "/crafty/stats"
        }
    }

    var url: URL? {
        let baseUrl = "https://\(UserDefaults.standard.string(forKey: CraftyConstants.serverUrl) ?? "")\(CraftyConstants.apiV2Suffix)"

        return URL(string: "\(baseUrl)\(path)")
    }

    var method: HTTPMethods {
        switch self {
        case .getStats:
            .get
        }
    }

    var body: Encodable? {
        switch self {
        case .getStats:
            nil
        }
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }
}
