//
//
// Created for Crafty iOS by hbq2dev
// ServersEndpoint.swift
//
//  Copyright © 2025 hbq2dev.
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
            return "/servers"
        case .postNewBedrockServer, .postNewJavaServer:
            return "/servers"
        case let .getServerStats(serverID):
            return "/servers/\(serverID)/stats"
        case let .getServerHistory(serverID):
            return "/servers/\(serverID)/history"
        case let .postServerAction(serverID, action):
            return "/servers/\(serverID)/action/\(action)"
        case let .getServerLogs(serverID):
            return "/servers/\(serverID)/logs"
        case let .postStdin(serverID, _):
            return "/servers/\(serverID)/stdin"
        case let .deleteServer(serverID):
            return "/servers/\(serverID)"
        case let .getServerBackupDetails(serverID, backupID):
            return "/servers/\(serverID)/backups/backup/\(backupID)"
        case let .getServerBackups(serverID):
            return "/servers/\(serverID)/backups"
        }
    }

    var url: URL? {
        let baseUrl = "https://\(UserDefaults.standard.string(forKey: CraftyConstants.serverUrl) ?? "")\(CraftyConstants.apiV2Suffix)"

        return URL(string: "\(baseUrl)\(path)")
    }

    var method: HTTPMethods {
        switch self {
        case .postNewBedrockServer, .postNewJavaServer, .postServerAction, .postStdin:
            return .post
        case .getServers, .getServerStats, .getServerHistory, .getServerLogs, .getServerBackupDetails, .getServerBackups:
            return .get
        case .deleteServer:
            return .delete
        }
    }

    var body: Encodable? {
        switch self {
        case .postServerAction, .deleteServer, .getServerStats, .getServers, .getServerLogs, .getServerHistory, .getServerBackupDetails,
             .getServerBackups:
            return nil
        case let .postNewBedrockServer(server):
            return server
        case let .postNewJavaServer(server):
            return server
        case let .postStdin(_, command):
            return command
        }
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }
}
