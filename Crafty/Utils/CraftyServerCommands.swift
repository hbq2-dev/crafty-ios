//
// Created for Crafty iOS by hbq2-dev
// CraftyServerCommands.swift
//
// Copyright (c) 2025 HBQ2
//

/// Available Crafty commands:
/// clone_server, start_server, stop_server, restart_server, kill_server, backup_server, update_executable

enum CraftyServerCommands {
    case startServer
    case stopServer
    case restartServer
    case deleteServer
}

extension CraftyServerCommands {
    var command: String {
        switch self {
        case .startServer:
            "start_server"
        case .stopServer:
            "stop_server"
        case .restartServer:
            "restart_server"
        case .deleteServer:
            ""
        }
    }

    var title: String {
        switch self {
        case .startServer:
            "Start Server"
        case .stopServer:
            "Stop Server"
        case .restartServer:
            "Restart Server"
        case .deleteServer:
            "Delete Server"
        }
    }

    var message: String {
        switch self {
        case .startServer:
            ""
        case .stopServer:
            "Are you sure you want to stop the server?"
        case .restartServer:
            "Are you sure you want to restart the server?"
        case .deleteServer:
            "Are you sure you want to delete this server? This action is not reversable. Please make sure you have a backup if necessary!"
        }
    }
}
