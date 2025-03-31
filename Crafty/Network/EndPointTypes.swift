//
// Created for Crafty iOS by hbq2-dev
// EndPointTypes.swift
//
// Copyright (c) 2025 HBQ2
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
