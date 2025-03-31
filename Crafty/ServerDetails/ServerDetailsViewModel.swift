//
// Created for Crafty iOS by hbq2-dev
// ServerDetailsViewModel.swift
//
// Copyright (c) 2025 HBQ2
//

import Combine
import Foundation

enum SocketStatus {
    case connected
    case disconnected
    case error
}

@MainActor
class ServerDetailsViewModel: ObservableObject {
    @Published
    private var webSocketConnectionTask: Task<Void, Never>?
    @Published
    private var connection: WebSocketConnection<WSUpdateServerDetailsResponse, String>?
    @Published
    var socketStatus: SocketStatus = .disconnected

    @Published
    var selectedServer: ApiServerStatusResponseDataClass?
    @Published
    var logsHtml = ""
    @Published
    var command: String = ""
    @Published
    var serverDeleted = false
    @Published
    var isLoading = false
    @Published
    var commandSuccess = false
    @Published
    var serverHistory: [ApiServerHistoryResponseDataClass] = []
    @Published
    var serverBackups: [ApiServerBackupsResponse] = []

    private var cancellables = Set<AnyCancellable>()

    private var serverManager: ServerServiceManagerProtocol?
    private var webSocketConnectionFactory: WebSocketConnectionFactory?

    init(serverManager: ServerServiceManagerProtocol) {
        self.serverManager = serverManager
    }

    func updateSelectedServer(server: ApiServerStatusResponseDataClass) {
        selectedServer = server
    }

    func setupWebSocket(webSocketConnectionFactory: WebSocketConnectionFactory?) {
        self.webSocketConnectionFactory = webSocketConnectionFactory

        webSocketConnectionTask?.cancel()

        webSocketConnectionTask = Task {
            await openAndConsumeWebSocketConnection()
        }
    }

    func resetConnection() async {
        await MainActor.run {
            webSocketConnectionTask = Task {
                await openAndConsumeWebSocketConnection()
            }
        }
    }

    func openAndConsumeWebSocketConnection() async {
        if selectedServer?.id == nil && selectedServer?.details?.id == nil {
            return
        }

        guard let baseUrl = UserDefaults.standard.string(forKey: CraftyConstants.serverUrl) else {
            return
        }

        let url =
            URL(
                string: "wss://\(baseUrl)/ws?page=%2Fpanel%2Fserver_detail&page_query_params=%3Fid%3D\((selectedServer?.id ?? selectedServer?.details?.id)!)%26subpage%3Dadmin"
            )!

        // Close any existing WebSocketConnection
        if let connection {
            connection.close()
        }

        let connection: WebSocketConnection<WSUpdateServerDetailsResponse, String>? = webSocketConnectionFactory?.open(at: url)

        self.connection = connection

        if let connection {
            do {
                for try await message in connection.receive() {
                    socketStatus = .connected

                    if let message = message as? WSUpdateServerDetailsResponse {
                        selectedServer = message.data

                        let maxId = serverHistory.map(\.id).max()
                        let newItem = ApiServerHistoryResponseDataClass(
                            id: (maxId ?? 0) + 1,
                            created: formattedDate(), cpu: message.data.cpu, memPercent: message
                                .data.memPercent,
                            online: message.data.online.integerValue
                        )

                        if serverHistory.isEmpty == false {
                            serverHistory.remove(at: 0)
                            serverHistory.append(newItem)
                        }
                    }
                    if let message = message as? WSTermNewLineReponse {
                        let str = message.data.line.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)

                        logsHtml.append("\(str)\n")
                    }
                    if let message = message as? WSNotificationResponse {
                        let str = message.data.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)

                        logsHtml.append("\(str)\n")

                        command = ""
                    }
                }
            } catch {
                disconnect()
                socketStatus = .error
            }
        }
    }

    func disconnect() {
        selectedServer = nil
        serverBackups.removeAll()
        serverHistory.removeAll()

        socketStatus = .disconnected
        webSocketConnectionTask?.cancel()
    }

    func fetchLogs() {
        isLoading = true

        if selectedServer?.id == nil && selectedServer?.details?.id == nil {
            return
        }
        serverManager?.getServerLogs(type: ServersEndpoint.getServerLogs(serverID: (selectedServer?.id ?? selectedServer?.details?.id)!))
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    print("Error \(error)")
                    self.isLoading = false

                case .finished:
                    print("Finished")
                }
            }, receiveValue: { logsResponse in
                guard let logs = logsResponse as? ApiServerLogsResponse else {
                    return
                }
                self.logsHtml = logs.data.joined(separator: "\n")

                self.isLoading = false
            })
            .store(in: &cancellables)
    }

    func fetchBackups() {
        isLoading = true

        if selectedServer?.id == nil && selectedServer?.details?.id == nil {
            return
        }
        serverManager?
            .getServerBackups(type: ServersEndpoint.getServerBackups(serverID: (selectedServer?.id ?? selectedServer?.details?.id)!))
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    print("Error \(error)")
                    self.isLoading = false

                case .finished:
                    print("Finished")
                }
            }, receiveValue: { backupsResponse in
                guard let backups = backupsResponse as? ApiServerBackups else {
                    return
                }

                self.serverBackups = backups.values.map(\.self)

                self.isLoading = false
            })
            .store(in: &cancellables)
    }

    func fetchHistory() {
        isLoading = true

        if selectedServer?.id == nil && selectedServer?.details?.id == nil {
            return
        }
        serverManager?
            .getServerHistory(type: ServersEndpoint.getServerHistory(serverID: (selectedServer?.id ?? selectedServer?.details?.id)!))
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    print("Error \(error)")
                    self.isLoading = false

                case .finished:
                    print("Finished")
                }
            }, receiveValue: { historyResponse in
                guard let history = historyResponse as? ApiServerHistoryResponse else {
                    return
                }

                self.serverHistory = history.data.suffix(12)
                self.isLoading = false
            })
            .store(in: &cancellables)
    }

    func postStdin() {
        isLoading = true

        if selectedServer?.id == nil && selectedServer?.details?.id == nil {
            return
        }
        serverManager?.postStdin(type: ServersEndpoint.postStdin(
            serverID: (selectedServer?.id ?? selectedServer?.details?.id)!,
            command: command
        ))
        .sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                print("Error \(error)")
                self.isLoading = false
                self.commandSuccess = false

            case .finished:
                print("Finished")
            }
        }, receiveValue: { _ in
            self.isLoading = false
            self.command = ""

            self.commandSuccess = true
        })
        .store(in: &cancellables)
    }

    func serverAction(action: CraftyServerCommands) {
        isLoading = true

        if selectedServer?.id == nil && selectedServer?.details?.id == nil {
            return
        }
        serverManager?.postServerAction(type: ServersEndpoint.postServerAction(
            serverID: (selectedServer?.id ?? selectedServer?.details?.id)!,
            action: action.command
        ))
        .sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                print("Error \(error)")
                self.isLoading = false
            case .finished:
                print("Finished")
            }
        }, receiveValue: { r in
            print("Status: \(r)")
            self.isLoading = false
        })
        .store(in: &cancellables)
    }

    func deleteServer() {
        isLoading = true

        if selectedServer?.id == nil && selectedServer?.details?.id == nil {
            return
        }
        serverManager?.deleteServer(type: ServersEndpoint.deleteServer(serverID: (selectedServer?.id ?? selectedServer?.details?.id)!))
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    print("Error \(error)")
                    self.isLoading = false

                case .finished:
                    print("Finished")
                }
            }, receiveValue: { r in
                print("Status: \(r)")
                self.serverDeleted = true
                self.isLoading = false
            })
            .store(in: &cancellables)
    }
}
