//
// Created for Crafty iOS by hbq2-dev
// ServersEndpoint.swift
//
// Copyright (c) 2025 HBQ2
//

import Foundation

enum ServersEndpoint {
    case getServers
    case postNewBedrockServer(model: APINewBedrockServerRequest)
    case postNewJavaServer(model: APINewJavaServerRequest)
    case getServerStats(serverID: String)
    case getServerHistory(serverID: String)
    case postServerAction(serverID: String, action: String)
    case getServerLogs(serverID: String)
    case postStdin(serverID: String, command: String)
    case deleteServer(serverID: String)
    case getServerBackupDetails(serverID: String, backupID: String)
    case getServerBackups(serverID: String)
}

extension ServersEndpoint: EndPointType {
    var path: String {
        switch self {
        case .getServers:
            "/servers"
        case .postNewBedrockServer, .postNewJavaServer:
            "/servers"
        case let .getServerStats(serverID):
            "/servers/\(serverID)/stats"
        case let .getServerHistory(serverID):
            "/servers/\(serverID)/history"
        case let .postServerAction(serverID, action):
            "/servers/\(serverID)/action/\(action)"
        case let .getServerLogs(serverID):
            "/servers/\(serverID)/logs"
        case let .postStdin(serverID, _):
            "/servers/\(serverID)/stdin"
        case let .deleteServer(serverID):
            "/servers/\(serverID)"
        case let .getServerBackupDetails(serverID, backupID):
            "/servers/\(serverID)/backups/backup/\(backupID)"
        case let .getServerBackups(serverID):
            "/servers/\(serverID)/backups"
        }
    }

    var url: URL? {
        let baseUrl = "https://\(UserDefaults.standard.string(forKey: CraftyConstants.serverUrl) ?? "")\(CraftyConstants.apiV2Suffix)"

        return URL(string: "\(baseUrl)\(path)")
    }

    var method: HTTPMethods {
        switch self {
        case .postNewBedrockServer, .postNewJavaServer, .postServerAction, .postStdin:
            .post
        case .getServers, .getServerStats, .getServerHistory, .getServerLogs, .getServerBackupDetails, .getServerBackups:
            .get
        case .deleteServer:
            .delete
        }
    }

    var body: Encodable? {
        switch self {
        case .postServerAction, .deleteServer, .getServerStats, .getServers, .getServerLogs, .getServerHistory, .getServerBackupDetails,
             .getServerBackups:
            nil
        case let .postNewBedrockServer(server):
            server
        case let .postNewJavaServer(server):
            server
        case let .postStdin(_, command):
            command
        }
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }
}
