//
//
// Created for Crafty iOS by hbq2dev
// BlurView.swift
//
//  Copyright © 2025 hbq2dev.
//

import Foundation
import SwiftUI

#if os(macOS)

@available(macOS 11, *)
public struct BlurView: NSViewRepresentable {
    public typealias NSViewType = NSVisualEffectView

    public func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.material = .hudWindow
        effectView.blendingMode = .withinWindow
        effectView.state = NSVisualEffectView.State.active
        return effectView
    }

    public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = .hudWindow
        nsView.blendingMode = .withinWindow
    }
}

#else

@available(iOS 14, *)
public struct BlurView: UIViewRepresentable {
    public typealias UIViewType = UIVisualEffectView

    public func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    }

    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: .systemMaterial)
    }
}

#endif
