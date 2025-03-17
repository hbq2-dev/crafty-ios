//
//
// Created for Crafty iOS by hbq2dev
// ApiServerStatsResponse.swift
//
//  Copyright © 2025 hbq2dev.
//

struct ApiServerStatsResponse: Codable {
    let status: String
    let data: ApiServerStatusResponseDataClass
}

struct ApiServerStatusResponseDataClass: Codable, Hashable {
    let id: String?
    let created: String
    let details: ApiServerResponse?
    let started: String
    let running: Bool
    let cpu: Double
    let memPercent: Int
    let worldName, worldSize: String
    let serverPort: Int
    let max: Int
    var online: Int
    let desc: String
    var playersCache: [ApiPlayerResponse]?
    let icon: String?
    let version: String
    let crashed: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case created
        case details = "server_id"
        case started, running, cpu
        case memPercent = "mem_percent"
        case worldName = "world_name"
        case worldSize = "world_size"
        case serverPort = "server_port"
        case playersCache = "players_cache"
        case online, max, desc, icon, version
        case crashed
    }
}
