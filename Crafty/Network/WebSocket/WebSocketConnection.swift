//
// Created for Crafty iOS by hbq2-dev
// WebSocketConnection.swift
//
// Copyright (c) 2025 HBQ2
//

import Foundation

/// Enumeration of possible errors that might occur while using ``WebSocketConnection``.
public enum WebSocketConnectionError: Error {
    case connectionError
    case transportError
    case encodingError
    case decodingError
    case disconnected
    case closed
}

/// A generic WebSocket Connection over an expected `Incoming` and `Outgoing` message type.
public final class WebSocketConnection<Incoming: Decodable & Sendable, Outgoing: Encodable & Sendable>: NSObject, Sendable {
    private let webSocketTask: URLSessionWebSocketTask

    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        webSocketTask: URLSessionWebSocketTask,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.webSocketTask = webSocketTask
        self.encoder = encoder
        self.decoder = decoder

        super.init()

        webSocketTask.resume()
    }

    deinit {
        // Make sure to cancel the WebSocketTask (if not already canceled or completed)
        webSocketTask.cancel(with: .goingAway, reason: nil)
    }

    private func receiveSingleMessage() async throws -> Any? {
        switch try await webSocketTask.receive() {
        case let .data(messageData):
            guard let _ = try? decoder.decode(Incoming.self, from: messageData) else {
                throw WebSocketConnectionError.decodingError
            }

            throw WebSocketConnectionError.decodingError

        case let .string(text):

            do {
                if let json = text.data(using: String.Encoding.utf8) {
                    if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String: AnyObject] {
                        print("Received message: \(json)")

                        if jsonData["event"] as? String == "update_server_details" {
                            print(jsonData)
                            guard let message = try? decoder.decode(WSUpdateServerDetailsResponse.self, from: json) else {
                                throw WebSocketConnectionError.decodingError
                            }

                            return message
                        } else if jsonData["event"] as? String == "update_server_status" {
                            print(jsonData)
                            guard let message = try? decoder.decode(WSUpdateServerStatus.self, from: json) else {
                                throw WebSocketConnectionError.decodingError
                            }

                            return message
                        } else if jsonData["event"] as? String == "vterm_new_line" {
                            guard let message = try? decoder.decode(WSTermNewLineReponse.self, from: json) else {
                                throw WebSocketConnectionError.decodingError
                            }

                            return message
                        } else if jsonData["event"] as? String == "notification" {
                            guard let message = try? decoder.decode(WSNotificationResponse.self, from: json) else {
                                throw WebSocketConnectionError.decodingError
                            }

                            return message
                        } else if jsonData["event"] as? String == "update_host_stats" {
                            guard let message = try? decoder.decode(WSUpdateHostStatsResponse.self, from: json) else {
                                throw WebSocketConnectionError.decodingError
                            }

                            return message
                        } else if jsonData["event"] as? String == "send_start_reload" {
                            return "Reload"
                        }
                    }
                }

                return nil
            } catch {
                print(error.localizedDescription)

                return nil
            }

        @unknown default:
            assertionFailure("Unknown message type")

            // Unsupported data, closing the WebSocket Connection
            webSocketTask.cancel(with: .unsupportedData, reason: nil)
            throw WebSocketConnectionError.decodingError
        }
    }
}

// MARK: Public Interface

extension WebSocketConnection {
    func send(_ message: Outgoing) async throws {
        guard let messageData = try? encoder.encode(message) else {
            throw WebSocketConnectionError.encodingError
        }

        do {
            try await webSocketTask.send(.data(messageData))
        } catch {
            switch webSocketTask.closeCode {
            case .invalid:
                throw WebSocketConnectionError.connectionError

            case .goingAway:
                throw WebSocketConnectionError.disconnected

            case .normalClosure:
                throw WebSocketConnectionError.closed

            default:
                throw WebSocketConnectionError.transportError
            }
        }
    }

    func receiveOnce() async throws -> Any? {
        do {
            return try await receiveSingleMessage()
        } catch let error as WebSocketConnectionError {
            throw error
        } catch {
            switch webSocketTask.closeCode {
            case .invalid:
                throw WebSocketConnectionError.connectionError

            case .goingAway:
                throw WebSocketConnectionError.disconnected

            case .normalClosure:
                throw WebSocketConnectionError.closed

            default:
                throw WebSocketConnectionError.transportError
            }
        }
    }

    func receive() -> AsyncThrowingStream<Any, Error> {
        AsyncThrowingStream { [weak self] in
            guard let self else {
                // Self is gone, return nil to end the stream
                return nil
            }

            let message = try await self.receiveOnce()

            // End the stream (by returning nil) if the calling Task was canceled
            return Task.isCancelled ? nil : message
        }
    }

    func close() {
        webSocketTask.cancel(with: .normalClosure, reason: nil)
    }
}
