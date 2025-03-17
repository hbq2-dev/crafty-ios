//
//
// Created for Crafty iOS by hbq2dev
// WSTermNewLineReponse.swift
//
//  Copyright © 2025 hbq2dev.
//

struct WSTermNewLineReponse: Codable {
    let event: String
    let data: WSTermNewLineReponseData
}

struct WSTermNewLineReponseData: Codable {
    let line: String
}
