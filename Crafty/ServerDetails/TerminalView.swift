//
// Created for Crafty iOS by hbq2-dev
// TerminalView.swift
//
// Copyright (c) 2025 HBQ2
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
            ScrollViewReader { value in
                ScrollView {
                    TextEditor(
                        text:
                        .constant(viewModel.logsHtml)
                    )
                    .font(.caption)
                    .foregroundColor(.teal)
                    .scrollIndicators(.hidden)
                }
                .frame(maxHeight: .infinity)
                .defaultScrollAnchor(.bottom)
                .onChange(of: viewModel.logsHtml) { _, _ in
                    value.scrollTo(viewModel.logsHtml.last, anchor: .bottom)
                }
                .onAppear {
                    withAnimation {
                        value.scrollTo(viewModel.logsHtml.last, anchor: .bottom)
                    }
                }
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
            }
        }.padding(8)
    }
}
