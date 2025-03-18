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
        Chart(viewModel.serverHistory) { entry in
            LineMark(
                x: .value("Time", entry.getTime()),
                y: .value("Total", entry.memPercent),
                series: .value("Metric", "Memory")
            ).foregroundStyle(.blue).interpolationMethod(.catmullRom)

            LineMark(
                x: .value("Time", entry.getTime()),
                y: .value("Total", entry.cpu),
                series: .value("Metric", "CPU")
            ).foregroundStyle(.red).interpolationMethod(.catmullRom)

            BarMark(
                x: .value("Time", entry.getTime()),
                y: .value("Value", entry.online)
            )
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.serverHistory)
        .padding()
        .onAppear {
            viewModel.fetchHistory()
        }
    }
}
