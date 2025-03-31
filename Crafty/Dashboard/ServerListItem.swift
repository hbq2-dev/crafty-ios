//
// Created for Crafty iOS by hbq2-dev
// ServerListItem.swift
//
// Copyright (c) 2025 HBQ2
//

import SwiftUI

struct ServerListItem: View {
    var serverDetails: ApiServerStatusResponseDataClass?
    var index: Int

    var body: some View {
        HStack {
            if serverDetails?.running == true {
                Image(systemName: "circle.fill").resizable().foregroundColor(.green).frame(width: 8.0, height: 8.0)
            } else {
                Image(systemName: "circle.fill").resizable().foregroundColor(.red).frame(width: 8.0, height: 8.0)
            }

            VStack {
                let icon = serverDetails?.icon?.stringValue ?? ""
                if let data = Data(base64Encoded: icon, options: .ignoreUnknownCharacters) {
                    let image = UIImage(data: data)

                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 40)
                            .clipShape(
                                .rect(cornerRadius: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.accent, lineWidth: 1)
                            )
                    } else {
                        Image("zombie")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 40)
                            .clipShape(
                                .rect(cornerRadius: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.accent, lineWidth: 1)
                            )
                    }
                } else {
                    Image("zombie")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 40)
                        .clipShape(
                            .rect(cornerRadius: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.accent, lineWidth: 1)
                        )
                }
                Text("\(serverDetails?.details?.type == "minecraft-java" ? "Java" : "Bedrock")").font(.caption)
                Text("\(serverDetails?.version?.stringValue ?? "N/A")").font(.caption)
            }.shadow(color: .craftyBlue.opacity(0.5), radius: 4, x: 0, y: 4)

            VStack(alignment: .leading) {
                HStack {
                    Text(serverDetails?.details?.serverName ?? "")
                        .font(.callout).fontWeight(.bold)
                }
                Text("\(serverDetails?.details?.serverIP ?? ""):\(String(serverDetails?.details?.serverPort ?? 0))").font(.caption)
                Text("CPU: \((serverDetails?.cpu ?? 0).formatted(.number.precision(.fractionLength(2))))%").font(.caption)
                Text("Memory: \(serverDetails?.mem?.stringValue ?? "N/A")").font(.caption)
            }
        }
    }
}
