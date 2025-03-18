//
// Created for Crafty iOS by hbq2-dev
// WebSocketConnectionFactory.swift
//
// Copyright (c) 2025 HBQ2
//

import Foundation

/// A simple factory protocol for creating concrete instances of ``WebSocketConnection``.
public protocol WebSocketConnectionFactory: Sendable {
    func open<Incoming: Decodable & Sendable, Outgoing: Encodable & Sendable>(at url: URL) -> WebSocketConnection<Incoming, Outgoing>
}

/// A default implementation of ``WebSocketConnectionFactory``.
public final class DefaultWebSocketConnectionFactory: Sendable {
    private let urlSession: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    /// Initialise a new instance of ``WebSocketConnectionFactory``.
    ///
    /// - Parameters:
    ///   - urlSession: URLSession used for opening WebSockets.
    ///   - encoder: JSONEncoder used to encode outgoing message bodies.
    ///   - decoder: JSONDecoder used to decode incoming message bodies.
    public init(
        urlSession: URLSession = URLSession.shared,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlSession = urlSession
        self.encoder = encoder
        self.decoder = decoder
    }
}

extension DefaultWebSocketConnectionFactory: WebSocketConnectionFactory {
    public func open<
        Incoming: Decodable & Sendable,
        Outgoing: Encodable & Sendable
    >(at url: URL) -> WebSocketConnection<Incoming, Outgoing> {
        var request = URLRequest(url: url)

        if let token = KeychainManager.instance.getToken(forKey: CraftyConstants.token) {
            request.setValue("\(CraftyConstants.token)=\(token)", forHTTPHeaderField: CraftyConstants.headerCookie)
        }

        let webSocketTask = urlSession.webSocketTask(with: request)

        return WebSocketConnection(
            webSocketTask: webSocketTask,
            encoder: encoder,
            decoder: decoder
        )
    }
}
