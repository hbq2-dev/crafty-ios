//
// Created for Crafty iOS by hbq2-dev
// CircleProgressView.swift
//
// Copyright (c) 2025 HBQ2
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
                    AngularGradient(
                        gradient: Gradient(colors: [.green, .yellow, .orange, .red]),
                        center: .center,
                        startAngle: .zero,
                        endAngle: .degrees(360)
                    ),
                    lineWidth: lineWidth
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.5), value: progress)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        var body: some View {
            CircleProgressView(progress: 0.22, lineWidth: 5)
        }
    }
    return PreviewWrapper()
}
