//
// Created for Crafty iOS by hbq2-dev
// CustomAlertModifier.swift
//
// Copyright (c) 2025 HBQ2
//

import SwiftUI

struct CraftyAlertModifier {
    // MARK: - Value

    // MARK: Private

    @Binding
    private var isPresented: Bool

    // MARK: Private

    private let title: String
    private let message: String
    private let dismissButton: CraftyAlertButton?
    private let primaryButton: CraftyAlertButton?
    private let secondaryButton: CraftyAlertButton?
}

extension CraftyAlertModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                CraftyAlertView(
                    title: title,
                    message: message,
                    dismissButton: dismissButton,
                    primaryButton: primaryButton,
                    secondaryButton: secondaryButton
                )
                .presentationBackground(.clear)
            }
            .transaction { transaction in
                if $isPresented.wrappedValue {
                    transaction.disablesAnimations = true

                    transaction.animation = .linear(duration: 0.1)
                }
            }
    }
}

extension CraftyAlertModifier {
    init(title: String = "", message: String = "", dismissButton: CraftyAlertButton, isPresented: Binding<Bool>) {
        self.title = title
        self.message = message
        self.dismissButton = dismissButton

        primaryButton = nil
        secondaryButton = nil

        _isPresented = isPresented
    }

    init(
        title: String = "",
        message: String = "",
        primaryButton: CraftyAlertButton,
        secondaryButton: CraftyAlertButton,
        isPresented: Binding<Bool>
    ) {
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton

        dismissButton = nil

        _isPresented = isPresented
    }
}
