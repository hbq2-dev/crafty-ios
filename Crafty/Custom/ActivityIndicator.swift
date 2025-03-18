//
// Created for Crafty iOS by hbq2-dev
// ActivityIndicator.swift
//
// Copyright (c) 2025 HBQ2
//

import SwiftUI

#if os(macOS)
@available(macOS 11, *)
struct ActivityIndicator: NSViewRepresentable {
    let color: Color

    func makeNSView(context: NSViewRepresentableContext<ActivityIndicator>) -> NSProgressIndicator {
        let nsView = NSProgressIndicator()

        nsView.isIndeterminate = true
        nsView.style = .spinning
        nsView.startAnimation(context)

        return nsView
    }

    func updateNSView(_: NSProgressIndicator, context _: NSViewRepresentableContext<ActivityIndicator>) {}
}
#else
@available(iOS 14, *)
struct ActivityIndicator: UIViewRepresentable {
    let color: Color

    func makeUIView(context _: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let progressView = UIActivityIndicatorView(style: .large)
        progressView.startAnimating()

        return progressView
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context _: UIViewRepresentableContext<ActivityIndicator>) {
        uiView.color = UIColor(color)
    }
}
#endif
