//
// Created for Crafty iOS by hbq2-dev
// WSUpdateHostStatsResponse.swift
//
// Copyright (c) 2025 HBQ2
//

import Foundation

// MARK: - WSUpdateHostStatsResponse

struct WSUpdateHostStatsResponse: Codable {
    let event: String
    let data: WSUpdateHostStatsResponseDataClass
}

// MARK: - WSUpdateHostStatsResponseDataClass

struct WSUpdateHostStatsResponseDataClass: Codable {
    let cpuUsage: Double
    let cpuCores: Int
    let cpuCurFreq: Double
    let cpuMaxFreq: Double
    let memPercent: Double
    let memUsage: String
    let diskUsage: [DiskUsage]?
    let mounts: String?

    enum CodingKeys: String, CodingKey {
        case cpuUsage = "cpu_usage"
        case cpuCores = "cpu_cores"
        case cpuCurFreq = "cpu_cur_freq"
        case cpuMaxFreq = "cpu_max_freq"
        case memPercent = "mem_percent"
        case memUsage = "mem_usage"
        case diskUsage = "disk_usage"
        case mounts
    }
}

// MARK: - DiskUsage

struct DiskUsage: Codable {
    let device: String
    let totalRaw: Int
    let total: String
    let usedRaw: Int
    let used: String
    let freeRaw: Int
    let free: String
    let percentUsed: Double
    let fs, mount: String

    enum CodingKeys: String, CodingKey {
        case device
        case totalRaw = "total_raw"
        case total
        case usedRaw = "used_raw"
        case used
        case freeRaw = "free_raw"
        case free
        case percentUsed = "percent_used"
        case fs, mount
    }
}
