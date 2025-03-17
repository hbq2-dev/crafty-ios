//
//
// Created for Crafty iOS by hbq2dev
// CircleProgressView.swift
//
//  Copyright © 2025 hbq2dev.
//

import SwiftUI

struct CircleProgressView: View {
    var progress: Double
    var lineWidth: CGFloat

    var body: some View {
        ZStack {
            Circle().stroke(
                .secondary.opacity(0.4),
                lineWidth: lineWidth
            )

            Circle()
                .trim(from: 0, to: min(progress, 1.0))
                .stroke(
                    .green.gradient,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.25), value: progress)
        }
    }
}
