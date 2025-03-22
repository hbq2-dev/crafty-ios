//
// Created for Crafty iOS by hbq2-dev
// LoginView.swift
//
// Copyright (c) 2025 HBQ2
//

import Combine
import SwiftUI

// MARK: - Main LoginView

struct LoginView: View {
    @EnvironmentObject
    var viewModel: LoginViewModel
    @Environment(\.orientation)
    private var orientation

    @State
    private var shouldNavigate = false

    @State
    private var shouldShowServerUrl = false

    private var isPhone: Bool = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone

    var body: some View {
        GeometryReader { metrics in
            NavigationStack {
                ZStack(
                    alignment: .center
                ) {
                    VStack(
                        alignment: .center
                    ) {
                        Spacer()
                        Form {
                            Section {
                                Image("crafty_logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(
                                        minWidth: 0,
                                        maxWidth: .infinity,
                                        minHeight: 0,
                                        maxHeight: .infinity,
                                        alignment: .topLeading
                                    )
                                CustomTextField(placeholder: "Enter Username", text: $viewModel.username)
                                CustomSecureField(placeholder: "Enter Password", text: $viewModel.password).padding(.bottom, 12)
                            }
                            Section {
                                Button(action: {
                                    viewModel.getToken(
                                        model: APILoginRequest(
                                            username: viewModel.username.lowercased(),
                                            password: viewModel.password
                                        )
                                    )
                                }) {
                                    Label("Login", systemImage: "person.badge.shield.checkmark")
                                }
                            }.disabled(!viewModel.isSubmitAllowed)
                            Section(
                                header: Text("Server Url Host"),
                                footer: Text("Only HTTPS endpoints with a valid certificate are allowed")
                            ) {
                                TextField("e.g. myserver.mc.com", text: $viewModel.serverUrl)
                                    .keyboardType(.URL)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
                                    .multilineTextAlignment(.leading)

                                Button(action: {
                                    let url = viewModel.serverUrl

                                    UserDefaults.standard.set(url.lowercased(), forKey: CraftyConstants.serverUrl)

                                    viewModel.fetchApiIndex()

                                    shouldShowServerUrl = false
                                    viewModel.showAlert = true
                                }) {
                                    Label("Save and Test Connection", systemImage: "server.rack")
                                }.disabled(viewModel.serverUrl.isEmpty)
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.4), radius: 4)
                        .frame(
                            width: metrics.size.width * (isPhone == true ? 0.85 : 0.55),
                            height: metrics.size.height * (isPhone == true ? 0.65 : (orientation.isPortrait ? 0.51 : 0.80)),
                            alignment: .center
                        )
                        Spacer()
                    }.foregroundStyle(.accent)
                        .padding()
                        .toast(isPresenting: $viewModel.showAlert) {
                            if viewModel.errorMessage == nil {
                                AlertToast(
                                    type: .complete(.accent),
                                    title: "Success",
                                    subTitle: "This server uses API version \(viewModel.apiIndex?.data.version ?? "")"
                                )
                            } else {
                                AlertToast(type: .error(.red), title: "Error", subTitle: "\(viewModel.errorMessage ?? "")")
                            }
                        }
                        .alert(
                            "Warning",
                            isPresented: $viewModel.showVersionWarning,
                            presenting: viewModel.apiIndex?.data
                        ) { _ in
                            Button("OK") {
                                /// NO-OP
                            }
                        } message: { data in
                            Text(
                                "This server uses API version \(data.version), but the versions support by this app are: \(viewModel.loadedConfig?.supportedServerVersions.joined(separator: ", ") ?? ""). Not all features may work as intented."
                            )
                        }
                        .toast(isPresenting: $viewModel.isLoading) {
                            AlertToast(type: .loading, title: "Loading", subTitle: "Please wait...")
                        }
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                )
                .background(
                    Image("LoginBackground").resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                )
                .onAppear {
                    viewModel.fetchConfig()
                }
            }
        }
    }
}
