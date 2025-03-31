//
// Created for Crafty iOS by hbq2-dev
// NewServerView.swift
//
// Copyright (c) 2025 HBQ2
//

import SwiftUI

struct NewServerView: View {
    @EnvironmentObject
    var viewModel: DashboardViewModel
    @Environment(\.dismiss)
    var dismiss

    @State
    private var selectedTab = 0

    var body: some View {
        VStack {
            HStack {
                Text("New Server").font(.largeTitle).padding()
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .foregroundColor(.accentColor)
                }
            }.padding()

            Picker("Server Type", selection: $selectedTab) {
                Text("Java").tag(0)
                Text("Bedrock").tag(1)
            }
            .pickerStyle(.segmented).padding(.horizontal, 16)

            if selectedTab == 0 {
                Form {
                    Section {
                        HStack {
                            Label("Type", systemImage: "gamecontroller")
                            Picker("", selection: $viewModel.newServerType) {
                                ForEach(CraftyConstants.serverTypes, id: \.self) {
                                    Text($0)
                                }
                            }
                        }

                        HStack {
                            Label("Version", systemImage: "tag")
                            Picker("", selection: $viewModel.newServerVersion) {
                                ForEach(CraftyConstants.serverVersions, id: \.self) {
                                    Text($0)
                                }
                            }
                        }

                        HStack {
                            Label("Min Memory", systemImage: "memorychip")
                            Picker("", selection: $viewModel.newServerMinMem) {
                                ForEach((1 ... 32).reversed(), id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            Text("GB")
                        }

                        HStack {
                            Label("Max Memory", systemImage: "memorychip.fill")
                            Picker("", selection: $viewModel.newServerMaxMem) {
                                ForEach((1 ... 32).reversed(), id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            Text("GB")
                        }

                        VStack(
                            alignment: .leading
                        ) {
                            Label("Server Name", systemImage: "pencil")
                            CustomTextField(placeholder: "Server Name", text: $viewModel.newServerName)
                        }

                        VStack(
                            alignment: .leading
                        ) {
                            Label("Server Port", systemImage: "network")
                            TextField("Server Port", value: $viewModel.newServerPort, formatter: CraftyConstants.noCommaFormatter())
                                .modifier(CustomTextFieldStyle(isFilled: viewModel.newServerPort != 0))
                                .keyboardType(.numberPad)
                        }
                    }.foregroundStyle(.accent)
                    Section {
                        Button(action: {
                            viewModel.showEULAAlert = true
                        }) {
                            Label("Build Server", systemImage: "externaldrive.badge.plus")
                        }
                    }
                    .foregroundStyle(.accent)
                    .disabled(
                        viewModel.newServerPort == 0 || viewModel.newServerName.isEmpty || viewModel.newServerMaxMem == 0
                    )
                    .alert(
                        title: "Legal Stuff",
                        message: "You must agree to the Minecraft EULA and the Microsoft Privacy Policy.",
                        primaryButton: CraftyAlertButton(
                            title: "Agree",
                            action: {
                                viewModel.showEULAAlert = false
                                viewModel.newJavaServer()

                                dismiss()
                            }
                        ),
                        secondaryButton: CraftyAlertButton(
                            title: "Cancel",
                            background: Color.red,
                            action: {
                                viewModel.showEULAAlert = false
                            }
                        ),
                        isPresented: $viewModel.showEULAAlert
                    )
                }
            } else if selectedTab == 1 {
                Form {
                    Section {
                        Label("Server Name", systemImage: "pencil")
                        CustomTextField(placeholder: "Server Name", text: $viewModel.newServerName)
                    }
                    Section {
                        Button(action: {
                            viewModel.showEULAAlert = true
                        }) {
                            Label("Build Server", systemImage: "externaldrive.badge.plus")
                        }
                    }.disabled(viewModel.newServerName.isEmpty)
                }
                .foregroundStyle(.accent)
                .alert(
                    title: "Legal Stuff",
                    message: "You must agree to the Minecraft EULA and the Microsoft Privacy Policy.",
                    primaryButton: CraftyAlertButton(
                        title: "Agree",
                        action: {
                            viewModel.showEULAAlert = false
                            viewModel.newBedrockServer()

                            dismiss()
                        }
                    ),
                    secondaryButton: CraftyAlertButton(
                        title: "Cancel",
                        background: Color.red,
                        action: {
                            viewModel.showEULAAlert = false
                        }
                    ),
                    isPresented: $viewModel.showEULAAlert
                )
            }
        }
    }
}
