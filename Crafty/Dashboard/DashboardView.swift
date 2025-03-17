//
//
// Created for Crafty iOS by hbq2dev
// DashboardView.swift
//
//  Copyright © 2025 hbq2dev.
//

import SwiftUI

struct DashboardView: View {
    @State
    private var selectedServer: ApiServerStatusResponseDataClass?
    @State
    private var showSheet = false
    @State
    private var columnVisibility = NavigationSplitViewVisibility.automatic

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
                .modifier(CustomButtonStyle(isEnabled: true)).padding(.vertical, 8)
            }.background(.craftyBackground)
        }

        detail: {
            if let selectedServer {
                ServerDetailsView(server: selectedServer)
            } else {
                VStack {
                    Image(systemName: "macwindow.badge.plus")
                    Text("Please select a server or create a new one")
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
                    columnVisibility = .all
                }
            }
    }
}

#Preview {
    @Previewable @State
    var value = true

    struct PreviewWrapper: View {
        var body: some View {
            CircleProgressView(progress: 0.22, lineWidth: 4)
            DashboardView().environmentObject(DashboardViewModel(
                statsManager: StatsServiceManager(),
                serverManager: ServerServiceManager()
            ))
        }
    }
    return PreviewWrapper()
}
