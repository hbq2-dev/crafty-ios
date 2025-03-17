//
//
// Created for Crafty iOS by hbq2dev
// EndPointTypes.swift
//
//  Copyright © 2025 hbq2dev.
//

import Foundation

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol EndPointType {
    var path: String { get }
    var url: URL? { get }
    var method: HTTPMethods { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
}
