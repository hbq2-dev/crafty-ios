//
// Created for Crafty iOS by hbq2-dev
// DashboardView.swift
//
// Copyright (c) 2025 HBQ2
//

import SwiftUI

struct DashboardView: View {
    @State
    private var selectedServer: ApiServerStatusResponseDataClass?
    @State
    private var showSheet = false
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

                            let serverStatsDetails = viewModel.serversStats?.filter { $0.data.details?.id == server.id }.first?.data

                            NavigationLink(value: serverStatsDetails) {
                                ServerListItem(serverDetails: serverStatsDetails)
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
                .padding(.vertical, 16)
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
        .navigationTitle("Dashboard")
            .onAppear {
                viewModel.fetchStats()

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
