//
// Created for Crafty iOS by hbq2-dev
// ServerDetailsView.swift
//
// Copyright (c) 2025 HBQ2
//

import SwiftUI

struct ServerDetailsView: View {
    let server: ApiServerStatusResponseDataClass?

    @Environment(\.webSocketConnectionFactory)
    private var webSocketConnectionFactory: WebSocketConnectionFactory

    @EnvironmentObject
    var dashboardViewModel: DashboardViewModel
    @EnvironmentObject
    var viewModel: ServerDetailsViewModel

    @State
    private var selectedTab = 0

    var body: some View {
        VStack(
            alignment: .leading
        ) {
            HStack {
                if server?.running == true {
                    Text("\(viewModel.selectedServer?.desc?.stringValue ?? "")").padding(.horizontal, 16)
                }
                Spacer()
                Image(server?.details?.type == "minecraft-java" ? "mc_java" : "mc_bedrock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.horizontal, 16)
            }
            VStack {
                HStack {
                    VStack(
                        alignment: .leading
                    ) {
                        if viewModel.selectedServer?.running == true {
                            Text("Version: \(viewModel.selectedServer?.version?.stringValue ?? "")").font(.caption)
                        }
                        if viewModel.selectedServer?.running == true {
                            Text("Status: Online").font(.caption)
                        } else {
                            Text("Status: Offline").font(.caption)
                        }
                        HStack {
                            switch viewModel.socketStatus {
                            case .connected:
                                VStack(
                                    alignment: .leading
                                ) {
                                    Text("Websocket: Connected").font(.caption)
                                    Button("Disconnect") {
                                        viewModel.disconnect()
                                    }
                                }
                            case .disconnected:
                                VStack(
                                    alignment: .leading
                                ) {
                                    Text("Websocket: Disconnected").font(.caption)
                                    Button("Connect") {
                                        viewModel.setupWebSocket(webSocketConnectionFactory: webSocketConnectionFactory)
                                    }
                                }
                            case .error:
                                VStack(
                                    alignment: .leading
                                ) {
                                    Text("Websocket Error").font(.caption)
                                    Button("Try Reconnecting") {
                                        viewModel.setupWebSocket(webSocketConnectionFactory: webSocketConnectionFactory)
                                    }.font(.caption)
                                }
                            }

                        }.buttonStyle(.bordered)
                    }
                    Spacer()
                    VStack(
                        alignment: .trailing
                    ) {
                        Text("World Size: \(viewModel.selectedServer?.worldSize ?? "")").font(.caption)
                        Text("CPU Usage: \(String(format: "%.0f", viewModel.selectedServer?.cpu ?? 0))%").font(.caption)
                        Text("Memory: \(viewModel.selectedServer?.memPercent ?? 0)%").font(.caption)
                        Text(
                            "Players: \(viewModel.selectedServer?.online?.integerValue ?? 0)/\(viewModel.selectedServer?.max?.integerValue ?? 0)"
                        )
                        .font(.caption)
                    }
                }.padding(.horizontal, 16)

                Picker("Tabs", selection: $selectedTab) {
                    Text("Commands").tag(0)
                    Text("Terminal").tag(1)
                    Text("Players").tag(2)
                    Text("Graphs").tag(3)
                    Text("Backups").tag(4)
                }
                .pickerStyle(.segmented).padding(.horizontal, 16)

                if selectedTab == 0 {
                    CommandsView()
                } else if selectedTab == 1 {
                    TerminalView()
                } else if selectedTab == 2 {
                    PlayersView()
                } else if selectedTab == 3 {
                    ChartView()
                } else if selectedTab == 4 {
                    BackupsView()
                }
                Spacer()
            }
        }
        .navigationTitle(server?.details?.serverName ?? "")
        .navigationBarTitleDisplayMode(.automatic)
        .onAppear {
            viewModel.updateSelectedServer(server: server!)
            viewModel.setupWebSocket(webSocketConnectionFactory: webSocketConnectionFactory)
            viewModel.fetchLogs()
        }
        .onDisappear {
            viewModel.disconnect()
        }.toast(isPresenting: $viewModel.commandSuccess) {
            AlertToast(type: .complete(.accent), title: "Success", subTitle: "Command executed successfully!")
        }.toast(isPresenting: $viewModel.isLoading) {
            AlertToast(type: .loading, title: "Loading", subTitle: "Please wait...")
        }
    }
}
