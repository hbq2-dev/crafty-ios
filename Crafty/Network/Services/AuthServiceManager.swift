//
// Created for Crafty iOS by hbq2-dev
// AuthServiceManager.swift
//
// Copyright (c) 2025 HBQ2
//

import Combine

protocol AuthServiceManagerProtocol {
    func apiIndex(type: EndPointType) -> Future<Any, DataError>
    func getToken(type: EndPointType) -> Future<Any, DataError>
    func getConfig(type: EndPointType) -> Future<Any, DataError>
}

final class AuthServiceManager: AuthServiceManagerProtocol {
    private var apiManager = APIManager()

    func apiIndex(type: EndPointType) -> Future<Any, DataError> {
        apiManager.request(modelType: ApiIndexResponse.self, type: type)
    }

    func getToken(type: EndPointType) -> Future<Any, DataError> {
        apiManager.request(modelType: ApiTokenResponse.self, type: type)
    }

    func getConfig(type: any EndPointType) -> Future<Any, DataError> {
        apiManager.request(modelType: ApiConfigResponse.self, type: type)
    }
}
