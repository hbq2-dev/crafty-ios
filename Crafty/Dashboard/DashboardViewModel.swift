//
// Created for Crafty iOS by hbq2-dev
// DashboardViewModel.swift
//
// Copyright (c) 2025 HBQ2
//

import Combine
import Foundation

class DashboardViewModel: ObservableObject {
    @Published
    var stats: ApiStatsResponse?
    @Published
    var servers: ApiServersResponse?
    @Published
    var serversStats: [ApiServerStatsResponse]?
    @Published
    var serverList: [ApiServerResponse] = []

    @Published
    var isLoading: Bool = false
    @Published
    var errorMessage: String?
    @Published
    var cpuPercentage: Double? = 0
    @Published
    var ramPercentage: Double? = 0

    @Published
    var onlinePlayers: Int = 0
    @Published
    var maxPlayers: Int = 0

    @Published
    var newServerName: String = ""
    @Published
    var newServerVersion: String = CraftyConstants.serverVersions.first ?? ""
    @Published
    var newServerType: String = CraftyConstants.serverTypes.first ?? ""
    @Published
    var newServerMinMem: Int = 1
    @Published
    var newServerMaxMem: Int = 2
    @Published
    var newServerPort: Int = 25565

    @Published
    var showEULAAlert = false

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    private var cancellables = Set<AnyCancellable>()

    private var statsManager: StatsServiceManagerProtocol?
    private var serverManager: ServerServiceManagerProtocol?

    init(statsManager: StatsServiceManagerProtocol, serverManager: ServerServiceManagerProtocol) {
        self.statsManager = statsManager
        self.serverManager = serverManager
    }

    func fetchStats() {
        isLoading = true
        errorMessage = nil

        statsManager?.getStats(type: StatsEndpoint.getStats)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    print("Error \(error)")
                case .finished:
                    print("Finished")
                }
            }, receiveValue: { response in
                guard let r = response as? ApiStatsResponse else {
                    return
                }

                self.isLoading = false
                self.stats = r
                self.cpuPercentage = r.data.cpuCurFreq / r.data.cpuMaxFreq
                self.ramPercentage = r.data.memPercent * 0.01

                self.fetchServers()
            })
            .store(in: &cancellables)
    }

    func fetchServers() {
        isLoading = true

        serverManager?.getServers(type: ServersEndpoint.getServers)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    print("Error \(error)")
                case .finished:
                    print("Finished")
                }
            }, receiveValue: { response in
                guard let r = response as? ApiServersResponse else {
                    return
                }

                self.servers = r

                self.getServersStats()
            })
            .store(in: &cancellables)
    }

    func getServersStats() {
        isLoading = true

        let publisher = Publishers
            .MergeMany((servers?.data.map { (serverManager?.getStatsForServer(type: ServersEndpoint.getServerStats(serverID: $0.id)))! })!)

        // Sink to receive the fetched data
        publisher
            .collect()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        self.isLoading = false

                    case let .failure(error):

                        self.isLoading = false
                        print("Error: \(error.localizedDescription)")
                    }
                },
                receiveValue: { data in
                    self.isLoading = false

                    guard let serverData = data as? [ApiServerStatsResponse] else {
                        return
                    }

                    let onlinePlayersCount: Int = serverData.compactMap(\.data.online).compactMap(\.integerValue).reduce(0, +)

                    let maxPlayersCount: Int = serverData.compactMap(\.data.max).compactMap(\.integerValue).reduce(0, +)

                    self.onlinePlayers = onlinePlayersCount
                    self.maxPlayers = maxPlayersCount

                    self.serversStats = serverData

                    self.serverList.removeAll()
                    for s in serverData {
                        guard let details = s.data.details else {
                            return
                        }
                        self.serverList.append(details)
                    }
                }
            ).store(in: &cancellables)
    }

    func newJavaServer() {
        isLoading = true

        serverManager?.postNewJavaServer(type: ServersEndpoint.postNewJavaServer(
            model:
            APINewJavaServerRequest(
                name: newServerName,
                monitoringType: "minecraft_java",
                minecraftJavaMonitoringData:
                MinecraftJavaMonitoringData(
                    host: "127.0.0.1",
                    port: newServerPort
                ),
                createType: "minecraft_java",
                minecraftJavaCreateData:
                MinecraftJavaCreateData(
                    createType: "download_jar",
                    downloadJarCreateData:
                    DownloadJarCreateData(
                        category: "mc_java_servers",
                        type: newServerType,
                        version: newServerVersion,
                        memMin: newServerMinMem,
                        memMax: newServerMaxMem,
                        serverPropertiesPort: newServerPort,
                        agreeToEULA: true
                    )
                )
            )
        ))
        .sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                self.isLoading = false
                print("Error \(error)")
            case .finished:
                print("Finished")
            }
        }, receiveValue: { response in
            guard let _ = response as? ApiNewServerResponse else {
                return
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.isLoading = false

                self.fetchStats()
            }
        })
        .store(in: &cancellables)
    }

    func newBedrockServer() {
        isLoading = true

        serverManager?.postNewBedrockServer(type: ServersEndpoint.postNewBedrockServer(model: APINewBedrockServerRequest(
            name: newServerName,
            monitoringType: "minecraft_bedrock",
            minecraftBedrockMonitoringData: MinecraftBedrockMonitoringData(
                host: "127.0.0.1",
                port: 19132
            ),
            createType: "minecraft_bedrock",
            minecraftBedrockCreateData: MinecraftBedrockCreateData(
                createType: "download_exe",
                downloadExeCreateData: DownloadExeCreateData(agreeToEULA: true)
            )
        )))
        .sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                print("Error \(error)")
            case .finished:
                print("Finished")
            }
        }, receiveValue: { response in
            guard let _ = response as? ApiNewServerResponse else {
                return
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.isLoading = false

                self.fetchStats()
            }
        })
        .store(in: &cancellables)
    }
}
