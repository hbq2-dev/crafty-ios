//
//
// Created for Crafty iOS by hbq2dev
// AlertExtension.swift
//
//  Copyright © 2025 hbq2dev.
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
