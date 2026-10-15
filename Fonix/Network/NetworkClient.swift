//
//  NetworkClient.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation

protocol NetworkClient {
    func send<R: APIRequest>(_ request: R) async throws -> R.Response
}

final class URLSessionNetworkClient: NetworkClient {
    private let baseURL: URL
    private let session: URLSession
    private let tokenProvider: () -> String?
    private let decoder: JSONDecoder

    init(baseURL: URL,
         session: URLSession = .shared,
         tokenProvider: @escaping () -> String? = { nil }) {
        self.baseURL = baseURL
        self.session = session
        self.tokenProvider = tokenProvider
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }

    func send<R: APIRequest>(_ request: R) async throws -> R.Response {
        let urlRequest = try makeURLRequest(for: request)
        AppLog.verbose("→ \(request.method.rawValue) \(request.path) \(request.parameters)")

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw APIError.transport(error.localizedDescription)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.transport("HTTP yanıtı değil")
        }
        guard (200..<300).contains(http.statusCode) else {
            throw APIError.httpStatus(http.statusCode)
        }

        let envelope: APIEnvelope<R.Response>
        do {
            envelope = try decoder.decode(APIEnvelope<R.Response>.self, from: data)
        } catch {
            throw APIError.decoding(String(describing: error))
        }

        guard envelope.success else {
            throw APIError.server(envelope.message ?? "Bilinmeyen sunucu hatası")
        }
        if let payload = envelope.data {
            return payload
        }
        if let empty = EmptyResponse() as? R.Response {
            return empty
        }
        throw APIError.emptyData
    }

    /// Test edilebilsin diye private değil.
    func makeURLRequest<R: APIRequest>(for request: R) throws -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(request.path),
                                             resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        if request.method == .get, !request.parameters.isEmpty {
            components.queryItems = request.parameters
                .map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                .sorted { $0.name < $1.name }
        }
        guard let url = components.url else { throw APIError.invalidURL }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(Locale.current.identifier, forHTTPHeaderField: "Accept-Language")

        if request.method != .get, !request.parameters.isEmpty {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: request.parameters)
            } catch {
                throw APIError.encoding(String(describing: error))
            }
        }

        if request.requiresAuth, let token = tokenProvider(), !token.isEmpty {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return urlRequest
    }
}
