//
// Created for Crafty iOS by hbq2-dev
// AlertExtension.swift
//
// Copyright (c) 2025 HBQ2
//

import SwiftUI

extension View {
    func alert(
        title: String = "",
        message: String = "",
        dismissButton: CraftyAlertButton = CraftyAlertButton(title: "ok", background: .accent),
        isPresented: Binding<Bool>
    ) -> some View {
        let title = NSLocalizedString(title, comment: "")
        let message = NSLocalizedString(message, comment: "")

        return modifier(CraftyAlertModifier(title: title, message: message, dismissButton: dismissButton, isPresented: isPresented))
    }

    func alert(
        title: String = "",
        message: String = "",
        primaryButton: CraftyAlertButton,
        secondaryButton: CraftyAlertButton,
        isPresented: Binding<Bool>
    ) -> some View {
        let title = NSLocalizedString(title, comment: "")
        let message = NSLocalizedString(message, comment: "")

        return modifier(CraftyAlertModifier(
            title: title,
            message: message,
            primaryButton: primaryButton,
            secondaryButton: secondaryButton,
            isPresented: isPresented
        ))
    }
}
