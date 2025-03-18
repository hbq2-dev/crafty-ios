//
// Created for Crafty iOS by hbq2-dev
// ServerListItem.swift
//
// Copyright (c) 2025 HBQ2
//

import SwiftUI

struct ServerListItem: View {
    var serverDetails: ApiServerStatusResponseDataClass?

    var body: some View {
        HStack {
            if serverDetails?.running == true {
                Image(systemName: "circle.fill").resizable().foregroundColor(.green).frame(width: 8.0, height: 8.0)
            } else {
                Image(systemName: "circle.fill").resizable().foregroundColor(.red).frame(width: 8.0, height: 8.0)
            }

            let icon = serverDetails?.icon ?? ""
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

            VStack(alignment: .leading) {
                Text(serverDetails?.details?.serverName ?? "")
                    .font(.callout)

                if serverDetails?.version != "False" {
                    Text("Version: \(serverDetails?.version ?? "")").font(.caption)

                    Text("\(serverDetails?.details?.serverIP ?? ""):\(String(serverDetails?.details?.serverPort ?? 0))").font(.caption)
                }
            }
        }
    }
}
