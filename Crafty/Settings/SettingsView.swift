//
// Created for Crafty iOS by hbq2-dev
// SettingsView.swift
//
// Copyright (c) 2025 HBQ2
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject
    var viewModel: LoginViewModel

    @StateObject
    private var settingsViewModel = SettingsViewModel()

    @State
    private var columnVisibility = NavigationSplitViewVisibility.doubleColumn

    @Environment(\.dismiss)
    var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Account") {
                        Button("Logout", systemImage: "person.badge.minus") {
                            settingsViewModel.clear()
                            viewModel.logout()
                        }
                    }
                    Section("Links") {
                        Link("Source Code", destination: URL(string: "https://github.com/hbq2-dev/crafty-ios")!)
                        Link("Report an Issue", destination: URL(string: "https://github.com/hbq2-dev/crafty-ios/issues")!)
                    }
                    Section {
                        Link("Crafty Controller Documentation", destination: URL(string: "https://docs.craftycontrol.com/")!)
                    }
                    header: {
                        Text("Crafty Controller")
                    }
                    footer: {
                        Text(
                            "Please do not report any issues with this app to the Crafty team as it is not supported or developed by them."
                        )
                    }
                    Section("Legal") {
                        Link(
                            "Privacy Policy",
                            destination: URL(string: UserDefaults.standard.string(forKey: CraftyConstants.privacyPolicyUrl)!)!
                        )
                        Link(
                            "Terms of Service",
                            destination: URL(string: UserDefaults.standard.string(forKey: CraftyConstants.termsOfServiceUrl)!)!
                        )
                    }

                    Text("Version: \(settingsViewModel.appVersion ?? "0")").font(.footnote)
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Label("Close", systemImage: "xmark.circle").fontWeight(.thin)
                    }
                }
            })
            .navigationTitle("Account")
            .onAppear {
                if UIDevice.current.userInterfaceIdiom == .pad &&
                    UIDevice.current.orientation.isPortrait
                {
                    columnVisibility = .all
                }
            }
        }
    }
}
