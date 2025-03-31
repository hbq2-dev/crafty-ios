//
// Created for Crafty iOS by hbq2-dev
// ServerServiceManager.swift
//
// Copyright (c) 2025 HBQ2
//

import Combine

protocol ServerServiceManagerProtocol {
    func getServers(type: EndPointType) -> Future<Any, DataError>
    func getStatsForServer(type: EndPointType) -> Future<Any, DataError>
    func postServerAction(type: EndPointType) -> Future<Any, DataError>
    func getServerLogs(type: EndPointType) -> Future<Any, DataError>
    func getServerHistory(type: EndPointType) -> Future<Any, DataError>
    func postStdin(type: EndPointType) -> Future<Any, DataError>
    func postNewBedrockServer(type: EndPointType) -> Future<Any, DataError>
    func postNewJavaServer(type: EndPointType) -> Future<Any, DataError>
    func deleteServer(type: EndPointType) -> Future<Any, DataError>
    func getServerBackupDetails(type: EndPointType) -> Future<Any, DataError>
    func getServerBackups(type: EndPointType) -> Future<Any, DataError>
}

final class ServerServiceManager: ServerServiceManagerProtocol {
    private var apiManager = APIManager()

    func getServers(type: EndPointType) -> Future<Any, DataError> {
        apiManager.request(modelType: ApiServersResponse.self, type: type)
    }

    func getStatsForServer(type: any EndPointType) -> Future<Any, DataError> {
        apiManager.request(modelType: ApiServerStatsResponse.self, type: type)
    }

    func getServerHistory(type: any EndPointType) -> Future<Any, DataError> {
        apiManager.request(modelType: ApiServerHistoryResponse.self, type: type)
    }

    func postServerAction(type: any EndPointType) -> Future<Any, DataError> {
        apiManager.request(modelType: ApiStatusResponse.self, type: type)
    }

    func getServerLogs(type: any EndPointType) -> Future<Any, DataError> {
        apiManager.request(modelType: ApiServerLogsResponse.self, type: type)
    }

    func postStdin(type: any EndPointType) -> Future<Any, DataError> {
        apiManager.request(modelType: ApiStatusResponse.self, type: type)
    }

    func postNewBedrockServer(type: any EndPointType) -> Future<Any, DataError> {
        apiManager.request(modelType: ApiNewServerResponse.self, type: type)
    }

    func postNewJavaServer(type: any EndPointType) -> Future<Any, DataError> {
        apiManager.request(modelType: ApiNewServerResponse.self, type: type)
    }

    func deleteServer(type: any EndPointType) -> Future<Any, DataError> {
        apiManager.request(modelType: ApiStatusResponse.self, type: type)
    }

    func getServerBackupDetails(type: any EndPointType) -> Future<Any, DataError> {
        apiManager.request(modelType: ApiServerBackupDetailsResponse.self, type: type)
    }

    func getServerBackups(type: any EndPointType) -> Future<Any, DataError> {
        apiManager.request(modelType: ApiServerBackups.self, type: type)
    }
}
