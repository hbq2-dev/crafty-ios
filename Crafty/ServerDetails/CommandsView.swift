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
        Menu {
            if viewModel.selectedServer?.running ?? false == false {
                Button(action: {
                    viewModel.serverAction(action: .startServer)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        dashboardViewModel.fetchStats()
                    }
                }) {
                    Label("Start", systemImage: "poweron")
                }
                .disabled(viewModel.selectedServer?.running ?? false == true)

                Button(action: {
                    confirmationDeleteShown = true
                }) {
                    Label("Delete", systemImage: "trash.circle")
                }
            } else {
                Button(action: {
                    confirmationRestartShown = true
                }) {
                    Label("Restart", systemImage: "togglepower")
                }
                .disabled(viewModel.selectedServer?.running ?? true == false)

                Button(action: {
                    confirmationStopShown = true
                }) {
                    Label("Power Off", systemImage: "power.circle")
                }
                .disabled(viewModel.selectedServer?.running ?? true == false)
            }
        } label: {
            Image(systemName: "ellipsis")
        }
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
    }
}

extension CommandsView {}
