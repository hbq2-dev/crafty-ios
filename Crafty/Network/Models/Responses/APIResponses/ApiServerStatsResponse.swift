//
// Created for Crafty iOS by hbq2-dev
// ApiServerStatsResponse.swift
//
// Copyright (c) 2025 HBQ2
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
    let max: IntOrStringAsInt?
    var online: IntOrStringAsInt?
    let desc: StringOrIntAsString?
    var playersCache: [ApiPlayerResponse]?
    let icon: StringOrBooleanAsString?
    let version: StringOrIntAsString?
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

struct IntOrStringAsInt: Codable, Equatable, Hashable {
    var integerValue: Int = 0

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self.integerValue = intValue
        }
        if let stringValue = try? container.decode(String.self) {
            self.integerValue = Int(stringValue) ?? 0
        }
    }
}

struct StringOrBooleanAsString: Codable, Equatable, Hashable {
    var stringValue: String = ""

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let _ = try? container.decode(Bool.self) {
            self.stringValue = ""
        }
        if let stringValue = try? container.decode(String.self) {
            self.stringValue = stringValue
        }
    }
}

struct StringOrIntAsString: Codable, Equatable, Hashable {
    var stringValue: String? = nil

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let _ = try? container.decode(Int.self) {
            self.stringValue = nil
        }
        if let stringValue = try? container.decode(String.self) {
            if stringValue == "False" {
                self.stringValue = nil
            } else {
                self.stringValue = stringValue
            }
        }
    }
}
