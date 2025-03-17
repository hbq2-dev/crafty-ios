//
//
// Created for Crafty iOS by hbq2dev
// ApiServerBackupsResponse.swift
//
//  Copyright © 2025 hbq2dev.
//

import Foundation

// MARK: - ApiServerBackupsResponse

struct ApiServerBackupsResponse: Codable, Identifiable, Hashable {
    let id, backupName, backupLocation, excludedDirs: String
    let maxBackups: Int
    let serverID: String
    let compress, shutdown: Bool
    let before, after: String
    let apiServerBackupsDefault, enabled: Bool

    enum CodingKeys: String, CodingKey {
        case id = "backup_id"
        case backupName = "backup_name"
        case backupLocation = "backup_location"
        case excludedDirs = "excluded_dirs"
        case maxBackups = "max_backups"
        case serverID = "server_id"
        case compress, shutdown, before, after
        case apiServerBackupsDefault = "default"
        case enabled
    }
}

typealias ApiServerBackups = [String: ApiServerBackupsResponse]
