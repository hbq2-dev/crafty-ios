//
// Created for Crafty iOS by hbq2-dev
// DashboardViewModel.swift
//
// Copyright (c) 2025 HBQ2
//

import Combine
import Foundation

@MainActor
class DashboardViewModel: ObservableObject {
    @Published
    private var webSocketConnectionTask: Task<Void, Never>?
    @Published
    private var connection: WebSocketConnection<WSUpdateHostStatsResponse, String>?
    @Published
    var socketStatus: SocketStatus = .disconnected

    @Published
    var stats: WSUpdateHostStatsResponseDataClass?
    @Published
    var servers: ApiServersResponse?
    @Published
    var serversStats = [ApiServerStatusResponseDataClass]()
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
    private var webSocketConnectionFactory: WebSocketConnectionFactory?

    init(statsManager: StatsServiceManagerProtocol, serverManager: ServerServiceManagerProtocol) {
        self.statsManager = statsManager
        self.serverManager = serverManager
    }

    func setupWebSocket(webSocketConnectionFactory: WebSocketConnectionFactory?) {
        self.webSocketConnectionFactory = webSocketConnectionFactory

        webSocketConnectionTask?.cancel()

        webSocketConnectionTask = Task {
            await openAndConsumeWebSocketConnection()
        }
    }

    func openAndConsumeWebSocketConnection() async {

        guard let baseUrl = UserDefaults.standard.string(forKey: CraftyConstants.serverUrl) else {
            return
        }

        let url =
            URL(
                string: "wss://\(baseUrl)/ws?page=%2Fpanel%2Fdashboard&page_query_params="
            )!

        // Close any existing WebSocketConnection
        if let connection {
            connection.close()
        }

        let connection: WebSocketConnection<WSUpdateHostStatsResponse, String>? = webSocketConnectionFactory?.open(at: url)

        self.connection = connection

        if let connection {
            do {
                for try await message in connection.receive() {
                    socketStatus = .connected

                    if let message = message as? String {
                        if message == "Reload" {
                            fetchServers()
                        }
                    }

                    if let message = message as? WSUpdateHostStatsResponse {
                        self.stats = message.data
                    }
                    if let message = message as? WSUpdateServerStatus {
                        for item in message.data {
                            let index = self.serversStats.firstIndex(where: { $0.details?.id == item.id })
                            var i = self.serversStats.first(where: { $0.details?.id == item.id })
                            i?.cpu = item.cpu
                            i?.online = item.online
                            i?.max = item.max
                            i?.running = item.running
                            i?.version = item.version
                            i?.icon = item.icon

                            self.serversStats.remove(at: index ?? 0)
                            self.serversStats.insert(i!, at: index ?? 0)
                        }
                    }
                }
            } catch {
                disconnect()
                socketStatus = .error
            }
        }
    }

    func disconnect() {
        socketStatus = .disconnected
        webSocketConnectionTask?.cancel()
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
                self.stats = WSUpdateHostStatsResponseDataClass(
                    cpuUsage: r.data.cpuUsage, cpuCores: r.data.cpuCores, cpuCurFreq: r.data.cpuCurFreq, cpuMaxFreq: r.data.cpuMaxFreq,
                    memPercent: r.data.memPercent, memUsage: r.data.memUsage, diskUsage: [], mounts: nil
                )
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

                    self.serversStats = serverData.map((\.data))

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
