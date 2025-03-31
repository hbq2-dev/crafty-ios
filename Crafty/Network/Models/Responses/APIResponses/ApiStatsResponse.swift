//
// Created for Crafty iOS by hbq2-dev
// ApiStatsResponse.swift
//
// Copyright (c) 2025 HBQ2
//

struct ApiStatsResponse: Codable {
    let status: String
    let data: ApiStatsResponseDataClass
}

struct ApiStatsResponseDataClass: Codable {
    let id: Int
    let time, bootTime: String
    let cpuUsage: Double
    let cpuCores: Int
    let cpuCurFreq, cpuMaxFreq: Double
    let memPercent: Double
    let memUsage, memTotal, diskJSON: String

    enum CodingKeys: String, CodingKey {
        case id
        case time
        case bootTime = "boot_time"
        case cpuUsage = "cpu_usage"
        case cpuCores = "cpu_cores"
        case cpuCurFreq = "cpu_cur_freq"
        case cpuMaxFreq = "cpu_max_freq"
        case memPercent = "mem_percent"
        case memUsage = "mem_usage"
        case memTotal = "mem_total"
        case diskJSON = "disk_json"
    }
}
