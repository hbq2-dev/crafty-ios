//
// Created for Crafty iOS by hbq2-dev
// CommandsView.swift
//
// Copyright (c) 2025 HBQ2
//

import SwiftUI

struct CommandsView: View {
    @EnvironmentObject
    var viewModel: ServerDetailsViewModel
    @EnvironmentObject
    var dashboardViewModel: DashboardViewModel

    @State
    private var confirmationRestartShown = false
    @State
    private var confirmationStopShown = false
    @State
    private var confirmationDeleteShown = false

    @Environment(\.dismiss)
    var dismiss

    var body: some View {
        HStack(
            alignment: .center
        ) {
            if viewModel.selectedServer?.running ?? false == false {
                Button(action: {
                    viewModel.serverAction(action: .startServer)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        dashboardViewModel.fetchStats()
                    }
                }) {
                    Label("Start", systemImage: "poweron")
                }
                .buttonStyle(.automatic)
                .tint(.green)
                .disabled(viewModel.selectedServer?.running ?? false == true)

                Button(action: {
                    confirmationDeleteShown = true
                }) {
                    Label("Delete", systemImage: "trash.circle")
                }
                .buttonStyle(.automatic)
                .tint(.red)
                .confirmationDialog("Delete Server", isPresented: $confirmationDeleteShown) {
                    Button("Delete Server", role: .destructive) {
                        viewModel.deleteServer()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            dismiss()

                            dashboardViewModel.fetchStats()
                        }
                    }
                } message: {
                    Text(
                        "Are you sure you want to delete this server? This action is not reversable. Please make sure you have a backup if necessary!"
                    )
                }
            } else {
                Button(action: {
                    confirmationRestartShown = true
                }) {
                    Label(UIDevice.current.userInterfaceIdiom == .pad ? "Restart" : "", systemImage: "togglepower")
                }
                .buttonStyle(.automatic)
                .tint(.yellow)
                .disabled(viewModel.selectedServer?.running ?? true == false)
                .confirmationDialog("Restart", isPresented: $confirmationRestartShown) {
                    Button("Restart Now", role: .destructive) {
                        viewModel.serverAction(action: .restartServer)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            dismiss()

                            dashboardViewModel.fetchStats()
                        }
                    }
                } message: {
                    Text("Are you sure you want to restart this server?")
                }

                Button(action: {
                    confirmationStopShown = true
                }) {
                    Label(UIDevice.current.userInterfaceIdiom == .pad ? "Stop" : "", systemImage: "power.circle")
                }
                .buttonStyle(.automatic)
                .tint(.pink)
                .disabled(viewModel.selectedServer?.running ?? true == false)
                .confirmationDialog("Stop", isPresented: $confirmationStopShown) {
                    Button("Stop Now", role: .destructive) {
                        viewModel.serverAction(action: .stopServer)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            dismiss()

                            dashboardViewModel.fetchStats()
                        }
                    }
                } message: {
                    Text("Are you sure you want to stop this server?")
                }
            }
        }
    }
}
