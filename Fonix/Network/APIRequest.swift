//
//  APIRequest.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

/// Her backend ucu bu protokole uyan bir struct olur.
protocol APIRequest {
    associatedtype Response: Decodable
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var requiresAuth: Bool { get }
}

extension APIRequest {
    var method: HTTPMethod { .post }
    var parameters: [String: Any] { [:] }
    var requiresAuth: Bool { true }
}

/// `data` alanı dönmeyen uçlar için.
struct EmptyResponse: Decodable {}
