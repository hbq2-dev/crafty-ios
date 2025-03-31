//
// Created for Crafty iOS by hbq2-dev
// WSUpdateServerStatus.swift
//
// Copyright (c) 2025 HBQ2
//

struct WSUpdateServerStatus: Codable {
    let event: String
    var data: [ApiServerStatusResponseDataClass]
}
