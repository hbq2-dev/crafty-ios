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
            HStack(
                alignment: .top
            ) {
                if server?.running == true {
                    VStack(
                        alignment: .leading
                    ) {
                        Text("\(viewModel.selectedServer?.desc?.stringValue ?? "")")

                        if viewModel.selectedServer?.running == true {
                            Text("Version: \(viewModel.selectedServer?.version?.stringValue ?? "")").font(.caption)
                            Text("Status: \(Text("Online").foregroundColor(.green))").font(.caption)

                            HStack {
                                switch viewModel.socketStatus {
                                case .connected:
                                    VStack(
                                        alignment: .leading
                                    ) {
                                        Text("Websocket: \(Text("Connected").foregroundColor(.green))").font(.caption)
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
                        } else {
                            Text("Status: \(Text("Offline").foregroundColor(.red))").font(.caption)
                        }
                    }.padding(.horizontal, 16)
                }
                Spacer()

                VStack(
                    alignment: .trailing
                ) {
                    Image(server?.details?.type == "minecraft-java" ? "mc_java" : "mc_bedrock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)

                    Text("World Size: \(viewModel.selectedServer?.worldSize ?? "")").font(.caption)
                    Text("CPU Usage: \(String(format: "%.0f", viewModel.selectedServer?.cpu ?? 0))%").font(.caption)
                    Text("Memory: \(viewModel.selectedServer?.memPercent ?? 0)%").font(.caption)
                    Text(
                        "Players: \(viewModel.selectedServer?.online.integerValue ?? 0)/\(viewModel.selectedServer?.max.integerValue ?? 0)"
                    )
                    .font(.caption)
                }.padding(.horizontal, 16)
            }
            VStack {
                Picker("Tabs", selection: $selectedTab) {
                    Text("Terminal").tag(0)
                    Text("Players").tag(1)
                    Text("Graphs").tag(2)
                    Text("Backups").tag(3)
                }
                .pickerStyle(.segmented).padding(.horizontal, 16)

                if selectedTab == 0 {
                    TerminalView()
                } else if selectedTab == 1 {
                    PlayersView()
                } else if selectedTab == 2 {
                    ChartView()
                } else if selectedTab == 3 {
                    BackupsView()
                }
                Spacer()
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                CommandsView()
            }
        })
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
