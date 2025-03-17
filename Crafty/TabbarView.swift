//
//
// Created for Crafty iOS by hbq2dev
// TabbarView.swift
//
//  Copyright © 2025 hbq2dev.
//

import Foundation
import SwiftUI

struct TabbarView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "list.dash.header.rectangle")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                        .foregroundStyle(.accent)
                }
        }
    }
}
