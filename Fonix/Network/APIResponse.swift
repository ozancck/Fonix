//
//  APIResponse.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation

struct APIEnvelope<Payload: Decodable>: Decodable {
    let success: Bool
    let message: String?
    let data: Payload?
}

enum APIError: Error, Equatable {
    case invalidURL
    case encoding(String)
    case transport(String)
    case httpStatus(Int)
    case server(String)
    case decoding(String)
    case emptyData
}
