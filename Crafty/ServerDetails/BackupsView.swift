//
//
// Created for Crafty iOS by hbq2dev
// BackupsView.swift
//
//  Copyright © 2025 hbq2dev.
//

import SwiftUI

struct BackupsView: View {
    @EnvironmentObject
    var viewModel: ServerDetailsViewModel

    var body: some View {
        VStack(
            alignment: .center
        ) {
            List(viewModel.serverBackups, id: \.self) { backup in
                VStack(
                    alignment: .leading
                ) {
                    HStack {
                        Text(backup.backupName).fontWeight(.bold).font(.headline)
                        if backup.apiServerBackupsDefault {
                            Text("Default Backup")
                                .padding(.horizontal, 8)
                                .background(.accent)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }

                    Text("Location: \(backup.backupLocation)").font(.subheadline)
                    Text("Max Backups: \(backup.maxBackups)")
                }
            }
        }.onAppear {
            viewModel.fetchBackups()
        }
    }
}
