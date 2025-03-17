//
//
// Created for Crafty iOS by hbq2dev
// CraftyAlertButton.swift
//
//  Copyright © 2025 hbq2dev.
//

import SwiftUI

struct CraftyAlertButton: View {
    // MARK: - Value

    // MARK: Public

    let title: LocalizedStringKey
    var background: Color? = nil
    var action: (() -> Void)? = nil

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
