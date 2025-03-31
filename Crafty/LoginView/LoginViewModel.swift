//
// Created for Crafty iOS by hbq2-dev
// LoginViewModel.swift
//
// Copyright (c) 2025 HBQ2
//

import Combine
import Foundation

class LoginViewModel: ObservableObject {
    @Published
    var apiIndex: ApiIndexResponse?
    @Published
    var loginResponse: ApiTokenResponse?

    @Published
    var isLoading: Bool = false
    @Published
    var errorMessage: String?
    @Published
    var isLoggedIn: Bool = KeychainManager.instance.getToken(forKey: CraftyConstants.token) != nil

    @Published
    var username: String = ""
    @Published
    var password: String = ""
    @Published
    var serverUrl: String = UserDefaults.standard.string(forKey: CraftyConstants.serverUrl) ?? ""

    @Published
    var isSubmitAllowed: Bool = false
    @Published
    var showAlert: Bool = false
    @Published
    var showVersionWarning: Bool = false

    var loadedConfig: ApiConfigResponse? = nil

    private var cancellables = Set<AnyCancellable>()

    private var serviceManager: AuthServiceManagerProtocol?

    init(serviceManager: AuthServiceManagerProtocol) {
        self.serviceManager = serviceManager

        Publishers.CombineLatest3($username, $password, $serverUrl)
            .map { username, password, serverUrl in
                !username.isEmpty && password.count >= 8 && !serverUrl.isEmpty
            }
            .assign(to: \.isSubmitAllowed, on: self)
            .store(in: &cancellables)
    }

    func fetchApiIndex() {
        isLoading = true
        errorMessage = nil

        serviceManager?.apiIndex(type: AuthEndpoint.apiIndex)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    if case let DataError.network(urlError) = error {
                        self.errorMessage = urlError?.localizedDescription
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                    self.isLoading = false
                    self.showAlert = true

                case .finished:
                    self.isLoading = false

                    if !self.loadedConfig!.supportedServerVersions.contains(self.apiIndex?.data.version ?? "") {
                        self.showVersionWarning = true
                    } else {
                        self.showAlert = true
                    }
                }
            }, receiveValue: { indexResponse in
                self.apiIndex = indexResponse as? ApiIndexResponse
            })
            .store(in: &cancellables)
    }

    func fetchConfig() {
        isLoading = true
        errorMessage = nil

        serviceManager?.getConfig(type: AuthEndpoint.getConfig)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    if case let DataError.network(urlError) = error {
                        self.errorMessage = urlError?.localizedDescription
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                    self.isLoading = false
                    self.showAlert = true

                case .finished:
                    self.isLoading = false
                }
            }, receiveValue: { configResponse in
                self.loadedConfig = configResponse as? ApiConfigResponse

                UserDefaults.standard.set(self.loadedConfig?.privacyPolicyUrl, forKey: CraftyConstants.privacyPolicyUrl)
                UserDefaults.standard.set(self.loadedConfig?.termsOfServiceUrl, forKey: CraftyConstants.termsOfServiceUrl)
            })
            .store(in: &cancellables)
    }

    func getToken(model: APILoginRequest) {
        isLoading = true
        errorMessage = nil

        serviceManager?.getToken(type: AuthEndpoint.getToken(model: model))
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    if case let DataError.network(urlError) = error {
                        self.errorMessage = urlError?.localizedDescription
                    } else if case DataError.unauthorized = error {
                        self.errorMessage = "Hmmm, those creds aren't quite right..."
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                    self.isLoading = false
                    self.showAlert = true

                case .finished:
                    print("Finished")
                }
            }, receiveValue: { response in
                guard let r = response as? ApiTokenResponse else {
                    return
                }
                do {
                    try KeychainManager.instance.saveToken(r.data.token, forKey: CraftyConstants.token)
                    self.loginResponse = r
                    self.isLoggedIn = true

                    self.username = ""
                    self.password = ""
                    self.isLoading = false
                } catch {
                    print(error)
                    self.isLoading = false
                }
            })
            .store(in: &cancellables)
    }

    func logout() {
        isLoggedIn = false
    }
}
