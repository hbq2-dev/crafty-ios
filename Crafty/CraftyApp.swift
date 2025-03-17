//
//
// Created for Crafty iOS by hbq2dev
// CraftyApp.swift
//
//  Copyright © 2025 hbq2dev.
//

import SwiftUI

struct WebSocketConnectionFactoryEnvironmentKey: EnvironmentKey {
    static let defaultValue: WebSocketConnectionFactory = DefaultWebSocketConnectionFactory()
}

extension EnvironmentValues {
    var webSocketConnectionFactory: WebSocketConnectionFactory {
        get { self[WebSocketConnectionFactoryEnvironmentKey.self] }
        set { self[WebSocketConnectionFactoryEnvironmentKey.self] = newValue }
    }
}

@main
struct CraftyApp: App {
    @StateObject
    var loginViewModel = LoginViewModel(serviceManager: AuthServiceManager())
    @StateObject
    var dashboardViewModel = DashboardViewModel(
        statsManager: StatsServiceManager(),
        serverManager: ServerServiceManager()
    )
    @StateObject
    var serverViewModel = ServerDetailsViewModel(
        serverManager: ServerServiceManager()
    )

    var body: some Scene {
        WindowGroup {
            GeometryReader { proxy in
                NavigationStack {
                    ApplicationSwitcher()
                }
                .environmentObject(loginViewModel)
                .environmentObject(dashboardViewModel)
                .environmentObject(serverViewModel)
                .environment(\.orientation, UIDevice.current.orientation)
                .environment(\.screenSize, proxy.size)
            }
        }
    }
}

struct ApplicationSwitcher: View {
    @EnvironmentObject
    var vm: LoginViewModel

    var body: some View {
        if vm.isLoggedIn {
            TabbarView()
        } else {
            LoginView()
        }
    }
}

extension EnvironmentValues {
    var orientation: UIDeviceOrientation {
        get { self[OrientationKey.self] }
        set { self[OrientationKey.self] = newValue }
    }

    var screenSize: CGSize {
        get { self[ScreenSizeKey.self] }
        set { self[ScreenSizeKey.self] = newValue }
    }
}

private struct OrientationKey: EnvironmentKey {
    static let defaultValue = UIDevice.current.orientation
}

private struct ScreenSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = .zero
}
