//
//
// Created for Crafty iOS by hbq2dev
// ApiNewServerResponse.swift
//
//  Copyright © 2025 hbq2dev.
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
