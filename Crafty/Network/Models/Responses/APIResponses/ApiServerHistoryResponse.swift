//
// Created for Crafty iOS by hbq2-dev
// ApiServerHistoryResponse.swift
//
// Copyright (c) 2025 HBQ2
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
