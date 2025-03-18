//
// Created for Crafty iOS by hbq2-dev
// ApiNewServerResponse.swift
//
// Copyright (c) 2025 HBQ2
//

import Foundation

// MARK: - APINewServerResponse

struct ApiNewServerResponse: Codable {
    let status: String
    let data: ApiNewServerResponseDataClass
}

// MARK: - ApiNewServerResponseDataClass

struct ApiNewServerResponseDataClass: Codable {
    let newServerID, newServerUUID: String

    enum CodingKeys: String, CodingKey {
        case newServerID = "new_server_id"
        case newServerUUID = "new_server_uuid"
    }
}
