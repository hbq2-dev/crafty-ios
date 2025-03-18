//
// Created for Crafty iOS by hbq2-dev
// APIManager.swift
//
// Copyright (c) 2025 HBQ2
//

import Combine
import Foundation

enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(error: URLError?)
    case decoding(error: Error?)
    case unknown(error: Error?)
    case unauthorized
}

typealias ResultHandler = Future

final class APIManager {
    static let shared = APIManager()
    private var cancellables = Set<AnyCancellable>()

    func request<T: Codable>(
        modelType _: T.Type,
        type: EndPointType
    ) -> ResultHandler<Any, DataError> {
        ResultHandler { [weak self] promise in
            guard let self, let url = type.url else {
                return promise(.failure(.invalidURL))
            }

            let request = self.getRequest(type: type, url: url)

            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap(self.responseDataHandler)
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { [weak self] completion in
                    guard let self else { return }
                    if case let .failure(error) = completion {
                        let error = self.errorHandler(error: error)
                        return promise(.failure(error))
                    }
                } receiveValue: { promise(.success($0)) }
                .store(in: &self.cancellables)
        }
    }

    func getRequest(type: EndPointType, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue

        if let token = KeychainManager.instance.getToken(forKey: CraftyConstants.token) {
            request.setValue("\(CraftyConstants.headerBearer) \(token)", forHTTPHeaderField: CraftyConstants.headerAuthorization)
        }

        if let parameters = type.body, type.method == .get {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.setQueryItems(with: parameters as! [String: String])
            request.url = components?.url
        } else if let parameters = type.body {
            if let string = parameters as? String {
                let data = string.data(using: .utf8)

                request.httpBody = data
            } else {
                request.httpBody = try? JSONEncoder().encode(parameters)
            }
        }

        request.allHTTPHeaderFields = type.headers
        return request
    }

    func responseDataHandler(data: Data, response: URLResponse) throws -> Data {
        if let response = response as? HTTPURLResponse,
           200 ... 299 ~= response.statusCode
        {
            return data
        } else if let response = response as? HTTPURLResponse,
                  401 ... 403 ~= response.statusCode
        {
            throw DataError.unauthorized
        } else {
            throw DataError.invalidResponse
        }
    }

    func errorHandler(error: Error) -> DataError {
        switch error {
        case let decodingError as DecodingError:
            .decoding(error: decodingError)
        case let urlError as URLError:
            .network(error: urlError)
        case let definedError as DataError:
            definedError
        default:
            .unknown(error: error)
        }
    }
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
