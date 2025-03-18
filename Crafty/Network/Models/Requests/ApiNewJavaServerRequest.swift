//
// Created for Crafty iOS by hbq2-dev
// ApiNewJavaServerRequest.swift
//
// Copyright (c) 2025 HBQ2
//

import Foundation

// MARK: - APINewJavaServerRequest

struct APINewJavaServerRequest: Codable {
    let name, monitoringType: String
    let minecraftJavaMonitoringData: MinecraftJavaMonitoringData
    let createType: String
    let minecraftJavaCreateData: MinecraftJavaCreateData

    enum CodingKeys: String, CodingKey {
        case name
        case monitoringType = "monitoring_type"
        case minecraftJavaMonitoringData = "minecraft_java_monitoring_data"
        case createType = "create_type"
        case minecraftJavaCreateData = "minecraft_java_create_data"
    }
}

// MARK: - MinecraftJavaCreateData

struct MinecraftJavaCreateData: Codable {
    let createType: String
    let downloadJarCreateData: DownloadJarCreateData

    enum CodingKeys: String, CodingKey {
        case createType = "create_type"
        case downloadJarCreateData = "download_jar_create_data"
    }
}

// MARK: - DownloadJarCreateData

struct DownloadJarCreateData: Codable {
    let category, type, version: String
    let memMin, memMax, serverPropertiesPort: Int
    let agreeToEULA: Bool

    enum CodingKeys: String, CodingKey {
        case category
        case type
        case version
        case memMin = "mem_min"
        case memMax = "mem_max"
        case serverPropertiesPort = "server_properties_port"
        case agreeToEULA = "agree_to_eula"
    }
}

// MARK: - MinecraftJavaMonitoringData

struct MinecraftJavaMonitoringData: Codable {
    let host: String
    let port: Int
}
