//
// Created for Crafty iOS by hbq2-dev
// SettingsViewModel.swift
//
// Copyright (c) 2025 HBQ2
//

import Combine
import Foundation

class SettingsViewModel: ObservableObject {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    func clear() {
        do {
            try KeychainManager.instance.deleteToken(forKey: CraftyConstants.token)
        } catch {}
    }
}
