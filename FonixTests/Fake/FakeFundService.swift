//
//  FakeFundService.swift
//  FonixTests
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
@testable import Fonix

final class FakeFundService: FundServicing {
    var homeDataResult: Result<HomeData, Error> = .failure(APIError.emptyData)
    var topEarnersResult: Result<[AssetSummary], Error> = .success([])
    var favoriteAssetsResult: Result<[FavoriteAsset], Error> = .success([])
    var fundCategoriesResult: Result<[FundCategory], Error> = .success([])
    var topFundsResult: Result<[AssetSummary], Error> = .success([])
    var searchFundsResult: Result<[AssetSummary], Error> = .success([])
    private(set) var requestedTopFundTypes: [TopFundType] = []
    private(set) var searchedQueries: [String] = []


    func homeData() async throws -> HomeData { try homeDataResult.get() }
    func topEarners() async throws -> [AssetSummary] { try topEarnersResult.get() }
    func favoriteAssets() async throws -> [FavoriteAsset] { try favoriteAssetsResult.get() }
    func fundCategories() async throws -> [FundCategory] { try fundCategoriesResult.get() }

    func topFunds(type: TopFundType) async throws -> [AssetSummary] {
        requestedTopFundTypes.append(type)
        return try topFundsResult.get()
    }

    func searchFunds(query: String) async throws -> [AssetSummary] {
        searchedQueries.append(query)
        return try searchFundsResult.get()
    }
}
