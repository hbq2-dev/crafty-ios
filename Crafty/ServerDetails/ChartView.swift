//
// Created for Crafty iOS by hbq2-dev
// ChartView.swift
//
// Copyright (c) 2025 HBQ2
//

import Charts
import SwiftUI

struct ChartView: View {
    @EnvironmentObject
    var viewModel: ServerDetailsViewModel

    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("CPU").font(.caption)
                    Color.craftyGreen.frame(width: 50, height: 3)
                }
                VStack {
                    Text("Memory").font(.caption)
                    Color.craftyPurple.frame(width: 50, height: 3)
                }
                VStack {
                    Text("Players").font(.caption)
                    Color.craftyBlue.frame(width: 50, height: 3)
                }
            }
            Chart(viewModel.serverHistory) { entry in
                LineMark(
                    x: .value("Time", entry.getTime()),
                    y: .value("Total", entry.memPercent),
                    series: .value("Metric", "Memory")
                ).foregroundStyle(.craftyPurple).interpolationMethod(.catmullRom)

                LineMark(
                    x: .value("Time", entry.getTime()),
                    y: .value("Total", entry.cpu),
                    series: .value("Metric", "CPU")
                ).foregroundStyle(.craftyGreen).interpolationMethod(.catmullRom)

                BarMark(
                    x: .value("Time", entry.getTime()),
                    y: .value("Value", entry.online)
                ).foregroundStyle(.craftyBlue).interpolationMethod(.catmullRom)
            }
            .animation(.easeInOut(duration: 0.2), value: viewModel.serverHistory)
        }.padding()
            .onAppear {
                viewModel.fetchHistory()
            }
    }
}
