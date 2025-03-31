//
// Created for Crafty iOS by hbq2-dev
// ApiNewBedrockServerRequest.swift
//
// Copyright (c) 2025 HBQ2
//

import Foundation

// MARK: - APINewBedrockServerRequest

struct APINewBedrockServerRequest: Codable {
    let name, monitoringType: String
    let minecraftBedrockMonitoringData: MinecraftBedrockMonitoringData
    let createType: String
    let minecraftBedrockCreateData: MinecraftBedrockCreateData

    enum CodingKeys: String, CodingKey {
        case name
        case monitoringType = "monitoring_type"
        case minecraftBedrockMonitoringData = "minecraft_bedrock_monitoring_data"
        case createType = "create_type"
        case minecraftBedrockCreateData = "minecraft_bedrock_create_data"
    }
}

// MARK: - MinecraftBedrockCreateData

struct MinecraftBedrockCreateData: Codable {
    let createType: String
    let downloadExeCreateData: DownloadExeCreateData

    enum CodingKeys: String, CodingKey {
        case createType = "create_type"
        case downloadExeCreateData = "download_exe_create_data"
    }
}

// MARK: - DownloadExeCreateData

struct DownloadExeCreateData: Codable {
    let agreeToEULA: Bool

    enum CodingKeys: String, CodingKey {
        case agreeToEULA = "agree_to_eula"
    }
}

// MARK: - MinecraftBedrockMonitoringData

struct MinecraftBedrockMonitoringData: Codable {
    let host: String
    let port: Int
}
