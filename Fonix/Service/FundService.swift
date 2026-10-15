//
//  FundServicing.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation

protocol FundServicing {
    func homeData() async throws -> HomeData
    func topEarners() async throws -> [AssetSummary]
    func favoriteAssets() async throws -> [FavoriteAsset]
}

final class FundService: FundServicing {
    private let client: NetworkClient

    init(client: NetworkClient) {
        self.client = client
    }

    func homeData() async throws -> HomeData {
        try await client.send(GetHomeDataRequest())
    }

    func topEarners() async throws -> [AssetSummary] {
        try await client.send(GetTopEarnersRequest())
    }

    func favoriteAssets() async throws -> [FavoriteAsset] {
        try await client.send(GetFavoriteAssetsRequest())
    }
}
