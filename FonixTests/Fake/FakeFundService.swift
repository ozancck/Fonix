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

    func homeData() async throws -> HomeData { try homeDataResult.get() }
    func topEarners() async throws -> [AssetSummary] { try topEarnersResult.get() }
    func favoriteAssets() async throws -> [FavoriteAsset] { try favoriteAssetsResult.get() }
}
