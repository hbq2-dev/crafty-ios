//
//
// Created for Crafty iOS by hbq2dev
// TerminalView.swift
//
//  Copyright © 2025 hbq2dev.
//

import SwiftUI

struct TerminalView: View {
    @EnvironmentObject
    var viewModel: ServerDetailsViewModel

    @State
    private var confirmationRestartShown = false
    @State
    private var confirmationStopShown = false

    var body: some View {
        VStack {
            ScrollView {
                TextEditor(
                    text:
                    .constant(viewModel.logsHtml)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(.caption)
                .foregroundColor(.teal)
                .scrollIndicators(.hidden)
            }
            .frame(maxHeight: .infinity)
            .defaultScrollAnchor(.bottom)
            Spacer()
            VStack {
                Label("Enter a command - the forward slash is already included", systemImage: "apple.terminal").font(.caption)

                HStack(
                    alignment: .center
                ) {
                    CustomTextField(placeholder: "e.g. gamerule doFireTick false", text: $viewModel.command)
                    Button("Send") {
                        viewModel.postStdin()
                    }
                    .buttonStyle(.borderedProminent).disabled(viewModel.command.isEmpty == true)
                }
            }
        }.padding(16)
    }
}
