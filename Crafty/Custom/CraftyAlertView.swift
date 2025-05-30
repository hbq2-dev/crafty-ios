//
// Created for Crafty iOS by hbq2-dev
// CraftyAlertView.swift
//
// Copyright (c) 2025 HBQ2
//

import SwiftUI

// Derived from: https://stackoverflow.com/questions/68178219/swiftui-creating-custom-alert

struct CraftyAlertView: View {
    // MARK: - Value

    // MARK: Public

    let title: String
    let message: String
    let dismissButton: CraftyAlertButton?
    let primaryButton: CraftyAlertButton?
    let secondaryButton: CraftyAlertButton?

    // MARK: Private

    @State
    private var opacity: CGFloat = 0
    @State
    private var backgroundOpacity: CGFloat = 0
    @State
    private var scale: CGFloat = 0.001

    @Environment(\.dismiss)
    private var dismiss

    // MARK: - View

    // MARK: Public

    var body: some View {
        ZStack {
            dimView

            alertView
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .ignoresSafeArea()
        .transition(.opacity)
        .task {
            animate(isShown: true)
        }
    }

    // MARK: Private

    private var alertView: some View {
        VStack(spacing: 20) {
            titleView
            messageView
            buttonsView
        }
        .padding(24)
        .frame(width: 320)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.4), radius: 16, x: 0, y: 12)
    }

    @ViewBuilder
    private var titleView: some View {
        if !title.isEmpty {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .lineSpacing(24 - UIFont.systemFont(ofSize: 18, weight: .bold).lineHeight)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    private var messageView: some View {
        if !message.isEmpty {
            Text(message)
                .font(.system(size: title.isEmpty ? 18 : 16))
                .foregroundColor(title.isEmpty ? .black : .gray)
                .lineSpacing(24 - UIFont.systemFont(ofSize: title.isEmpty ? 18 : 16).lineHeight)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var buttonsView: some View {
        HStack(spacing: 12) {
            if dismissButton != nil {
                dismissButtonView

            } else if primaryButton != nil, secondaryButton != nil {
                secondaryButtonView
                primaryButtonView
            }
        }
        .padding(.top, 23)
    }

    @ViewBuilder
    private var primaryButtonView: some View {
        if let button = primaryButton {
            CraftyAlertButton(title: button.title, background: .accent) {
                animate(isShown: false) {
                    dismiss()
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    button.action?()
                }
            }
        }
    }

    @ViewBuilder
    private var secondaryButtonView: some View {
        if let button = secondaryButton {
            CraftyAlertButton(title: button.title, background: Color.red) {
                animate(isShown: false) {
                    dismiss()
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    button.action?()
                }
            }
        }
    }

    @ViewBuilder
    private var dismissButtonView: some View {
        if let button = dismissButton {
            CraftyAlertButton(title: button.title) {
                animate(isShown: false) {
                    dismiss()
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    button.action?()
                }
            }
        }
    }

    private var dimView: some View {
        Color.black
            .opacity(0.80)
            .opacity(backgroundOpacity)
    }

    // MARK: - Function

    // MARK: Private

    private func animate(isShown: Bool, completion: (() -> Void)? = nil) {
        switch isShown {
        case true:
            opacity = 1

            withAnimation(.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 0).delay(0.5)) {
                backgroundOpacity = 1
                scale = 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion?()
            }

        case false:
            withAnimation(.easeOut(duration: 0.2)) {
                backgroundOpacity = 0
                opacity = 0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                completion?()
            }
        }
    }
}

#if DEBUG
struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        let dismissButton = CraftyAlertButton(title: "OK")
        let primaryButton = CraftyAlertButton(title: "OK")
        let secondaryButton = CraftyAlertButton(title: "Cancel")

        let title = "This is your life. Do what you want and do it often."
        let message = """
        If you don't like something, change it.
        If you don't like your job, quit.
        If you don't have enough time, stop watching TV.
        """

        return VStack {
            CraftyAlertView(title: title, message: message, dismissButton: nil, primaryButton: nil, secondaryButton: nil)
            CraftyAlertView(title: title, message: message, dismissButton: dismissButton, primaryButton: nil, secondaryButton: nil)
            CraftyAlertView(
                title: title,
                message: message,
                dismissButton: nil,
                primaryButton: primaryButton,
                secondaryButton: secondaryButton
            )
        }
        .previewDevice("iPhone 13 Pro Max")
        .preferredColorScheme(.light)
    }
}
#endif
