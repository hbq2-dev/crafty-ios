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
    private var columnVisibility = NavigationSplitViewVisibility.automatic

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Account") {
                        Button("Logout", systemImage: "person.badge.minus") {
                            do {
                                try KeychainManager.instance.deleteToken(forKey: CraftyConstants.token)
                                viewModel.logout()
                            } catch {}
                        }
                    }
                    Section("Links") {
                        Link("Crafty Controller Docs", destination: URL(string: "https://docs.craftycontrol.com/")!)
                        Link("Source Code", destination: URL(string: "https://docs.craftycontrol.com/")!)
                    }
                    Section("Privacy Policy") {
                        Text(
                            "This app does not collect any personal data and does not use any analytics service.\nThe only information sent is API data to your Crafty instance, and the only third party data provider is https://mc-heads.net/avatar to receive player head information."
                        )
                    }
                }

                Text("Version: \(settingsViewModel.appVersion ?? "0")").font(.footnote)
            }
            .navigationTitle("Settings")
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
