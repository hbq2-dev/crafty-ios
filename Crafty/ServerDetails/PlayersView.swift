//
// Created for Crafty iOS by hbq2-dev
// PlayersView.swift
//
// Copyright (c) 2025 HBQ2
//

import SwiftUI

struct PlayersView: View {
    @EnvironmentObject
    var viewModel: ServerDetailsViewModel

    var body: some View {
        VStack(
            alignment: .center
        ) {
            if viewModel.selectedServer?.playersCache?.isEmpty == true {
                Spacer()
                HStack(
                    alignment: .center
                ) {
                    Text("No players found or server is offline.").font(.caption).padding(32)
                }
                Spacer()
            } else {
                List(viewModel.selectedServer?.playersCache ?? [], id: \.self) { player in
                    VStack(
                        alignment: .leading
                    ) {
                        HStack {
                            if player.status == "Online" {
                                Image(systemName: "circle.fill").resizable().foregroundColor(.green).frame(width: 10.0, height: 10.0)
                            } else {
                                Image(systemName: "circle.fill").resizable().foregroundColor(.red).frame(width: 10.0, height: 10.0)
                            }

                            let urlString = "https://mc-heads.net/avatar/\(player.name)/35/player.png"
                            AsyncCachedImage(
                                url: URL(string: urlString),
                                content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 35, height: 35)
                                },
                                placeholder: {
                                    ProgressView()
                                }
                            )
                            .fixedSize()
                            .listRowInsets(.init(.zero))
                            .id(player.id)
                            VStack(
                                alignment: .leading
                            ) {
                                Text(player.name).fontWeight(.light).font(.body)
                                Text("Last Seen:").font(.caption)
                                Text("\(player.lastSeen)").font(.caption2)
                            }
                            Spacer()
                        }
                        HStack {
                            Button("Ban") {
                                viewModel.command = "ban \(player.name)"
                                viewModel.postStdin()
                            }
                            .buttonStyle(.borderedProminent)
                            Button("Kick") {
                                viewModel.command = "kick \(player.name)"
                                viewModel.postStdin()
                            }
                            .buttonStyle(.bordered)
                            Button("Op") {
                                viewModel.command = "op \(player.name)"
                                viewModel.postStdin()
                            }
                            .buttonStyle(.borderedProminent)
                            Button("De-OP") {
                                viewModel.command = "deop \(player.name)"
                                viewModel.postStdin()
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }
        }.onAppear {
            viewModel.selectedServer?.playersCache = []
        }
    }
}
