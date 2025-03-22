//
// Created for Crafty iOS by hbq2-dev
// TabbarView.swift
//
// Copyright (c) 2025 HBQ2
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

            // TODO: Revisit nav stack
//            SettingsView()
//                .tabItem {
//                    Label("Settings", systemImage: "gear")
//                }
        }
    }
}
