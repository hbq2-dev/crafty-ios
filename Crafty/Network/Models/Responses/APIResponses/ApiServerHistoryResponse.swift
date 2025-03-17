//
//
// Created for Crafty iOS by hbq2dev
// ApiServerHistoryResponse.swift
//
//  Copyright © 2025 hbq2dev.
//

// MARK: - ApiServerHistoryResponse

struct ApiServerHistoryResponse: Codable {
    let status: String
    let data: [ApiServerHistoryResponseDataClass]
}

// MARK: - ApiServerHistoryResponseDataClass

struct ApiServerHistoryResponseDataClass: Codable, Hashable, Identifiable {
    let id: Int
    let created: String
    let cpu: Double
    let memPercent: Int
    var online: Int

    enum CodingKeys: String, CodingKey {
        case id = "stats_id"
        case created
        case cpu
        case memPercent = "mem_percent"
        case online
    }

    func getTime() -> String {
        created.formattedTime() ?? ""
    }
}
