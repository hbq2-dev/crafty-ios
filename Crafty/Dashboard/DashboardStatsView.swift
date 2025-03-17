//
//
// Created for Crafty iOS by hbq2dev
// DashboardStatsView.swift
//
//  Copyright © 2025 hbq2dev.
//

import SwiftUI

struct DashboardStatsView: View {
    @EnvironmentObject
    var viewModel: DashboardViewModel

    var body: some View {
        VStack(
            alignment: .leading
        ) {
            HStack(
                alignment: .top
            ) {
                VStack(
                    alignment: .leading
                ) {
                    Label("Memory", systemImage: "memorychip").font(.subheadline).fontWeight(.semibold).frame(height: 16)
                    ProgressView(value: viewModel.stats?.data.memPercent, total: 100)
                    Text("\(viewModel.stats?.data.memUsage ?? "") / \(viewModel.stats?.data.memTotal ?? "")").font(.footnote)
                    Text("\((viewModel.stats?.data.memPercent ?? 0).formatted(.number.precision(.fractionLength(0))))%").font(.footnote)
                }
                Spacer()
                VStack(
                    alignment: .trailing
                ) {
                    Label("CPU", systemImage: "cpu").font(.subheadline).fontWeight(.semibold).frame(height: 16)
                    ProgressView(value: viewModel.stats?.data.cpuUsage ?? 0, total: 100)
                    Text("\(viewModel.stats?.data.cpuCores ?? 0) Cores").font(.footnote)
                    Text(
                        "\(viewModel.stats?.data.cpuCurFreq.formatted(.number.precision(.fractionLength(0))) ?? "") / \(viewModel.stats?.data.cpuMaxFreq.formatted() ?? "") MHz"
                    )
                    .font(.footnote)
                    Text("\(((viewModel.cpuPercentage ?? 0) * 100).formatted(.number.precision(.fractionLength(0))))%").font(.footnote)
                }
            }

            HStack(
                alignment: .top
            ) {
                VStack(
                    alignment: .leading
                ) {
                    Label("Servers", systemImage: "server.rack").font(.subheadline).fontWeight(.semibold)
                    Text(
                        "\(viewModel.serversStats?.filter { $0.data.running == true }.count ?? 0) Online / \(viewModel.servers?.data.count ?? 0) Offline"
                    )
                    .font(.footnote).padding(.bottom, 16)
                }
                Spacer()
                VStack(
                    alignment: .trailing
                ) {
                    Label("Players", systemImage: "person").font(.subheadline).fontWeight(.semibold)
                    Text("\(viewModel.onlinePlayers) Online / \(viewModel.maxPlayers) Max").font(.footnote)
                }
            }
        }
    }
}
