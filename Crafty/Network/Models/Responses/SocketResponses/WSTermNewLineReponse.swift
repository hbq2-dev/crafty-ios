//
// Created for Crafty iOS by hbq2-dev
// WSTermNewLineReponse.swift
//
// Copyright (c) 2025 HBQ2
//

struct WSTermNewLineReponse: Codable {
    let event: String
    let data: WSTermNewLineReponseData
}

struct WSTermNewLineReponseData: Codable {
    let line: String
}
