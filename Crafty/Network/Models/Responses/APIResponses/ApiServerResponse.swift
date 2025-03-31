//
// Created for Crafty iOS by hbq2-dev
// ApiServerResponse.swift
//
// Copyright (c) 2025 HBQ2
//

import Foundation

struct ApiServerResponse: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    let created, serverName, path: String
    let executable, logPath, executionCommand: String
    let autoStart: Bool
    let autoStartDelay: Int
    let crashDetection: Bool
    let stopCommand, executableUpdateURL, serverIP: String
    let serverPort, logsDeleteAfter: Int
    let type: String
    let showStatus: Bool
    let createdBy, shutdownTimeout: Int
    let ignoredExits: String
    let countPlayers: Bool

    enum CodingKeys: String, CodingKey {
        case id = "server_id"
        case created
        case serverName = "server_name"
        case path, executable
        case logPath = "log_path"
        case executionCommand = "execution_command"
        case autoStart = "auto_start"
        case autoStartDelay = "auto_start_delay"
        case crashDetection = "crash_detection"
        case stopCommand = "stop_command"
        case executableUpdateURL = "executable_update_url"
        case serverIP = "server_ip"
        case serverPort = "server_port"
        case logsDeleteAfter = "logs_delete_after"
        case type
        case showStatus = "show_status"
        case createdBy = "created_by"
        case shutdownTimeout = "shutdown_timeout"
        case ignoredExits = "ignored_exits"
        case countPlayers = "count_players"
    }
}
