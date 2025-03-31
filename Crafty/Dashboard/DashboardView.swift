//
// Created for Crafty iOS by hbq2-dev
// DashboardView.swift
//
// Copyright (c) 2025 HBQ2
//

import SwiftUI

struct DashboardView: View {
    @Environment(\.webSocketConnectionFactory)
    private var webSocketConnectionFactory: WebSocketConnectionFactory

    @State
    private var selectedServer: ApiServerStatusResponseDataClass?
    @State
    private var showSheet = false
    @State
    private var showSettings = false
    @State
    private var columnVisibility =
        NavigationSplitViewVisibility.doubleColumn

    @EnvironmentObject
    var viewModel: DashboardViewModel

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            VStack(
                alignment: .leading
            ) {
                List(selection: $selectedServer) {
                    Section {
                        Image("crafty_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(
                                minWidth: 0,
                                maxWidth: .infinity,
                                minHeight: 0,
                                maxHeight: .infinity,
                                alignment: .topLeading
                            )
                    }
                    Section {
                        DashboardStatsView()
                    }
                    Section {
                        ForEach(viewModel.serverList) { server in

                            let serverStatsDetails = viewModel.serversStats.filter { $0.details?.id == server.id }.first

                            NavigationLink(value: serverStatsDetails) {
                                ServerListItem(serverDetails: serverStatsDetails, index: viewModel.serverList.firstIndex(of: server) ?? 0)
                            }
                        }
                    }
                }
                .refreshable {
                    viewModel.fetchServers()
                }
                .listStyle(.inset)

                Button(action: {
                    showSheet.toggle()
                }) {
                    Label("New Server", systemImage: "plus.circle").fontWeight(.thin)
                }
                .sheet(isPresented: $showSheet) {
                    NewServerView()
                        .presentationBackground(.thinMaterial)
                }
                .modifier(CustomButtonStyle(isEnabled: true))
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showSettings.toggle()
                        }) {
                            Label("Account", systemImage: "person.crop.circle").fontWeight(.thin)
                        }
                        .sheet(isPresented: $showSettings) {
                            SettingsView()
                                .presentationBackground(.thinMaterial)
                        }
                    }
                })
            }
        }

        detail: {
            if let selectedServer {
                ServerDetailsView(server: selectedServer)
            } else {
                VStack {
                    Image(systemName: "macwindow.badge.plus")
                    Text("Select a server or create a new one")

                    Button(action: {
                        showSheet.toggle()
                    }) {
                        Label("New Server", systemImage: "plus.circle").fontWeight(.thin)
                    }
                    .sheet(isPresented: $showSheet) {
                        NewServerView()
                            .presentationBackground(.thinMaterial)
                    }
                    .modifier(CustomButtonStyle(isEnabled: true))
                    .padding(.vertical, 16)
                    .frame(width: 250)
                }
            }
        }.toast(isPresenting: $viewModel.isLoading) {
            AlertToast(type: .loading, title: "Loading", subTitle: "Please wait...")
        }
        .onDisappear {
                viewModel.disconnect()
            }
            .navigationTitle("Dashboard")
            .onAppear {
                viewModel.fetchStats()
                viewModel.setupWebSocket(webSocketConnectionFactory: webSocketConnectionFactory)

                if UIDevice.current.userInterfaceIdiom == .pad &&
                    UIDevice.current.orientation.isPortrait
                {
                    columnVisibility = .doubleColumn
                }
            }
    }
}

#Preview {
    @Previewable @State
    var value = true

    struct PreviewWrapper: View {
        var body: some View {
            DashboardView().environmentObject(DashboardViewModel(
                statsManager: StatsServiceManager(),
                serverManager: ServerServiceManager()
            ))
        }
    }
    return PreviewWrapper()
}
