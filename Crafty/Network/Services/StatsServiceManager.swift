//
//
// Created for Crafty iOS by hbq2dev
// StatsServiceManager.swift
//
//  Copyright © 2025 hbq2dev.
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
