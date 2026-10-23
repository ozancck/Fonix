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
    func fundCategories() async throws -> [FundCategory]
    func topFunds(type: TopFundType) async throws -> [AssetSummary]
    func searchFunds(query: String) async throws -> [AssetSummary]
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
    
    func fundCategories() async throws -> [FundCategory] {
        try await client.send(GetFundCategoriesRequest())
    }

    func topFunds(type: TopFundType) async throws -> [AssetSummary] {
        try await client.send(GetTopFundsRequest(type: type))
    }

    func searchFunds(query: String) async throws -> [AssetSummary] {
        try await client.send(SearchFundsRequest(query: query))
    }
}
