//
// Created for Crafty iOS by hbq2-dev
// CraftyAlertButton.swift
//
// Copyright (c) 2025 HBQ2
//

import SwiftUI

struct CraftyAlertButton: View {
    // MARK: - Value

    // MARK: Public

    let title: LocalizedStringKey
    var background: Color?
    var action: (() -> Void)?

    // MARK: - View

    // MARK: Public

    var body: some View {
        Button {
            action?()

        } label: {
            Text(title)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
        }
        .frame(width: 100, height: 50)
        .background(background ?? .accentColor)
        .cornerRadius(8)
    }
}
