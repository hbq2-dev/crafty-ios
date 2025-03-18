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
        }
    }
}
