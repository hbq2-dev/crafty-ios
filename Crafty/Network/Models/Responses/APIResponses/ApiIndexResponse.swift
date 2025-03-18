//
// Created for Crafty iOS by hbq2-dev
// ApiIndexResponse.swift
//
// Copyright (c) 2025 HBQ2
//

struct ApiIndexResponse: Codable, Hashable {
    let status: String
    let data: ApiIndexResponseData
}

struct ApiIndexResponseData: Codable, Hashable {
    let version, message: String
}
