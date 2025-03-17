//
//
// Created for Crafty iOS by hbq2dev
// ServerDetailsView.swift
//
//  Copyright © 2025 hbq2dev.
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
                Spacer()
                if server?.running == true {
                    Text("\(server?.desc ?? "")").font(.footnote).padding(.horizontal, 16)
                }
                Spacer()
            }
            HStack {
                VStack(
                    alignment: .leading
                ) {
                    if server?.details?.type == "minecraft-java" {
                        Image("mc_java")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 35)
                            .padding(8)
                    } else {
                        Image("mc_bedrock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 35)
                            .padding(8)
                    }
                    if viewModel.selectedServer?.running == true {
                        Text("Version: \(server?.version ?? "")")
                    }
                    if viewModel.selectedServer?.running == true {
                        Text("Status: Online")
                    } else {
                        Text("Status: Offline")
                    }

                    HStack {
                        switch viewModel.socketStatus {
                        case .connected:
                            VStack(
                                alignment: .leading
                            ) {
                                Label("Websocket Status: \(viewModel.socketStatus)", systemImage: "wifi").font(.caption2)
                                Button("Disconnect") {
                                    viewModel.disconnect()
                                }
                            }
                        case .disconnected:
                            VStack(
                                alignment: .leading
                            ) {
                                Label("Websocket Status: \(viewModel.socketStatus)", systemImage: "wifi.slash").font(.caption2)
                                Button("Connect") {
                                    viewModel.setupWebSocket(webSocketConnectionFactory: webSocketConnectionFactory)
                                }
                            }
                        case .error:
                            VStack(
                                alignment: .leading
                            ) {
                                Label("Websocket Status: \(viewModel.socketStatus)", systemImage: "wifi.exclamationmark").font(.caption2)
                                Button("Try Reconnecting") {
                                    viewModel.setupWebSocket(webSocketConnectionFactory: webSocketConnectionFactory)
                                }
                            }
                        }

                    }.buttonStyle(.bordered)
                    Text("Server must be started to use this feature").font(.caption2).bold()
                }
                Spacer()
                VStack(
                    alignment: .trailing
                ) {
                    Text("World Size: \(viewModel.selectedServer?.worldSize ?? "")")
                    Text("CPU Usage: \(String(format: "%.0f", viewModel.selectedServer?.cpu ?? 0))%")
                    Text("Memory: \(viewModel.selectedServer?.memPercent ?? 0)%")
                    Text("Players: \(viewModel.selectedServer?.online ?? 0)/\(server?.max ?? 0)")
                }
            }.padding(.horizontal, 16)
            Picker("Tabs", selection: $selectedTab) {
                Text("Commands").tag(0)
                Text("Terminal").tag(1)
                Text("Players").tag(2)
                Text("Graphs").tag(3)
                Text("Backups").tag(4)
            }
            .pickerStyle(.segmented).padding(16)

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
