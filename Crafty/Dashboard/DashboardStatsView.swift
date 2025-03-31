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
                alignment: .top,
                spacing: 10
            ) {
                VStack(
                    alignment: .leading
                ) {
                    ZStack {
                        CircleProgressView(progress: viewModel.ramPercentage ?? 0, lineWidth: 6).frame(height: 100)

                        VStack {
                            Label("RAM", systemImage: "memorychip").fontWeight(.semibold).font(.caption)
                            Text("\((viewModel.stats?.memPercent ?? 0).formatted(.number.precision(.fractionLength(0))))%")
                                .font(.footnote)
                        }
                    }
                    .padding(.vertical, 8)
                    Text("\(viewModel.stats?.memUsage ?? "") Used")
                        .font(.footnote)
                }.frame(maxWidth: .infinity)

                VStack(
                    alignment: .center
                ) {
                    ZStack {
                        CircleProgressView(progress: (viewModel.stats?.diskUsage?.first?.percentUsed ?? 0) / 100, lineWidth: 6)
                            .frame(height: 100)

                        VStack {
                            Label("Disk", systemImage: "internaldrive").fontWeight(.semibold).font(.caption)
                            Text(
                                "\((viewModel.stats?.diskUsage?.first?.percentUsed ?? 0).formatted(.number.precision(.fractionLength(2))))%"
                            )
                            .font(.footnote)
                        }
                    }.padding(.vertical, 8)
                    Text(
                        "\(viewModel.stats?.diskUsage?.first?.used ?? "") / \(viewModel.stats?.diskUsage?.first?.total ?? "")"
                    ).font(.footnote)
                }.frame(maxWidth: .infinity)

                VStack(
                    alignment: .trailing
                ) {
                    ZStack {
                        CircleProgressView(progress: (viewModel.stats?.cpuUsage ?? 0) / 100, lineWidth: 6).frame(height: 100)

                        VStack {
                            Label("CPU", systemImage: "cpu").fontWeight(.semibold).font(.caption)
                            Text("\(viewModel.stats?.cpuUsage.formatted(.number.precision(.fractionLength(2))) ?? "")%")
                                .font(.footnote)
                        }
                    }.padding(.vertical, 8)
                    Text("\(viewModel.stats?.cpuCores ?? 0) Cores").font(.footnote)
                    Text(
                        "\(viewModel.stats?.cpuCurFreq.formatted(.number.precision(.fractionLength(0))) ?? "") / \(viewModel.stats?.cpuMaxFreq.formatted() ?? "") MHz"
                    )
                    .font(.footnote)
                }.frame(maxWidth: .infinity)
            }

            HStack(
                alignment: .top
            ) {
                VStack(
                    alignment: .leading
                ) {
                    Label("Servers", systemImage: "server.rack").font(.subheadline).fontWeight(.semibold)
                    Text(
                        "\(viewModel.serversStats.filter { $0.running == true }.count) Online / \(viewModel.servers?.data.count ?? 0) Total"
                    )
                    .font(.footnote).padding(.bottom, 16)
                }
                Spacer()
                VStack(
                    alignment: .trailing
                ) {
                    Label("Players", systemImage: "person").font(.subheadline).fontWeight(.semibold)
                    Text(
                        "\(viewModel.serversStats.map(\.online.integerValue).reduce(0, +)) Online / \(viewModel.serversStats.map(\.max.integerValue).reduce(0, +)) Max"
                    )
                    .font(.footnote)
                }
            }
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
