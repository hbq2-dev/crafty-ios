//
// Created for Crafty iOS by hbq2-dev
// DashboardStatsView.swift
//
// Copyright (c) 2025 HBQ2
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
                    ZStack {
                        CircleProgressView(progress: viewModel.ramPercentage ?? 0, lineWidth: 6).frame(height: 100)

                        VStack {
                            Label("RAM", systemImage: "memorychip").fontWeight(.semibold)
                            Text("\((viewModel.stats?.data.memPercent ?? 0).formatted(.number.precision(.fractionLength(0))))%")
                                .font(.footnote)
                        }
                    }
                    .padding(.vertical, 8)
                    Text("\(viewModel.stats?.data.memUsage ?? "") / \(viewModel.stats?.data.memTotal ?? "")").font(.footnote)
                }
                Spacer()
                VStack(
                    alignment: .trailing
                ) {
                    ZStack {
                        CircleProgressView(progress: viewModel.cpuPercentage ?? 0, lineWidth: 6).frame(height: 100)

                        VStack {
                            Label("CPU", systemImage: "cpu").fontWeight(.semibold)
                            Text("\(((viewModel.cpuPercentage ?? 0) * 100).formatted(.number.precision(.fractionLength(0))))%")
                                .font(.footnote)
                        }
                    }.padding(.vertical, 8)
                    Text("\(viewModel.stats?.data.cpuCores ?? 0) Cores").font(.footnote)
                    Text(
                        "\(viewModel.stats?.data.cpuCurFreq.formatted(.number.precision(.fractionLength(0))) ?? "") / \(viewModel.stats?.data.cpuMaxFreq.formatted() ?? "") MHz"
                    )
                    .font(.footnote)
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
                        "\(viewModel.serversStats?.filter { $0.data.running == true }.count ?? 0) Online / \(viewModel.servers?.data.count ?? 0) Total"
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
            }.padding(.vertical, 8)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        var body: some View {
            DashboardStatsView().environmentObject(DashboardViewModel(
                statsManager: StatsServiceManager(),
                serverManager: ServerServiceManager()
            ))
        }
    }
    return PreviewWrapper()
}
