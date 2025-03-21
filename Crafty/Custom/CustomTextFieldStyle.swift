//
// Created for Crafty iOS by hbq2-dev
// CustomTextFieldStyle.swift
//
// Copyright (c) 2025 HBQ2
//

import SwiftUI

// MARK: - Reusable TextFieldStyle

struct CustomTextFieldStyle: ViewModifier {
    var isFilled: Bool

    func body(content: Content) -> some View {
        content
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(isFilled ? Color.blue : Color.gray.opacity(0.4), lineWidth: 1)
            )
    }
}

// MARK: - Reusable ButtonStyle

struct CustomButtonStyle: ViewModifier {
    var isEnabled: Bool

    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(isEnabled ? .white : .black)
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(isEnabled ? Color.craftyBackground : Color.white.opacity(0.5))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isEnabled ? Color.white : Color.gray.opacity(0.4), lineWidth: 1)
            )
            .shadow(color: isEnabled ? .craftyBlue.opacity(0.5) : Color.clear, radius: 8, x: 0, y: 8)
            .padding(16)
            .animation(.easeInOut(duration: 1.0), value: isEnabled)
    }
}

struct SmallCustomButtonStyle: ViewModifier {
    var isEnabled: Bool
    var color: Color

    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(isEnabled ? .white : .black)
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(isEnabled ? color : Color.white.opacity(0.5))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isEnabled ? Color.white : Color.gray.opacity(0.4), lineWidth: 0.5)
            )
            .shadow(color: isEnabled ? color.opacity(0.4) : Color.clear, radius: 10, x: 0, y: 10)
            .padding(.horizontal, 4)
            .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }
}

// MARK: - Custom TextField and SecureField

struct CustomTextField: View {
    var placeholder: String
    @Binding
    var text: String

    var body: some View {
        TextField(placeholder, text: $text).textInputAutocapitalization(.never)
            .modifier(CustomTextFieldStyle(isFilled: !text.isEmpty))
    }
}

struct CustomSecureField: View {
    var placeholder: String
    @Binding
    var text: String

    var body: some View {
        SecureField(placeholder, text: $text)
            .modifier(CustomTextFieldStyle(isFilled: !text.isEmpty))
    }
}
