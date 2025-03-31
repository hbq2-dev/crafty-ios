//
// Created for Crafty iOS by hbq2-dev
// StatsServiceManager.swift
//
// Copyright (c) 2025 HBQ2
//

import Combine

protocol StatsServiceManagerProtocol {
    func getStats(type: EndPointType) -> Future<Any, DataError>
}

final class StatsServiceManager: StatsServiceManagerProtocol {
    private var apiManager = APIManager()

    func getStats(type: EndPointType) -> Future<Any, DataError> {
        apiManager.request(modelType: ApiStatsResponse.self, type: type)
    }
}
