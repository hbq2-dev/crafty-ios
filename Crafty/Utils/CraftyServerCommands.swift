//
//
// Created for Crafty iOS by hbq2dev
// CraftyServerCommands.swift
//
//  Copyright © 2025 hbq2dev.
//

/// Available Crafty commands:
/// clone_server, start_server, stop_server, restart_server, kill_server, backup_server, update_executable

enum CraftyServerCommands {
    case startServer
    case stopServer
    case restartServer
}

extension CraftyServerCommands {
    var command: String {
        return switch self {
        case .startServer:
            "start_server"
        case .stopServer:
            "stop_server"
        case .restartServer:
            "restart_server"
        }
    }
}
