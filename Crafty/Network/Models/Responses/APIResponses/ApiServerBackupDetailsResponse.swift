//
//
// Created for Crafty iOS by hbq2dev
// ApiServerBackupDetailsResponse.swift
//
//  Copyright © 2025 hbq2dev.
//

import Foundation

// MARK: - ApiServerBackupDetailsResponse

struct ApiServerBackupDetailsResponse: Codable {
    let backupID, backupName, backupLocation, excludedDirs: String
    let maxBackups: Int
    let serverID: ApiServerResponse
    let compress, shutdown: Bool
    let before, after: String
    let apiServerBackupDetailsDefault: Bool
    let status: ApiServerBackupDetailsStatus
    let enabled: Bool

    enum CodingKeys: String, CodingKey {
        case backupID = "backup_id"
        case backupName = "backup_name"
        case backupLocation = "backup_location"
        case excludedDirs = "excluded_dirs"
        case maxBackups = "max_backups"
        case serverID = "server_id"
        case compress, shutdown, before, after
        case apiServerBackupDetailsDefault = "default"
        case status, enabled
    }
}

struct ApiServerBackupDetailsStatus: Codable {
    let status, message: String
}
