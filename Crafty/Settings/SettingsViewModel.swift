//
//
// Created for Crafty iOS by hbq2dev
// SettingsViewModel.swift
//
//  Copyright © 2025 hbq2dev.
//

import Combine
import Foundation

class SettingsViewModel: ObservableObject {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}
