//
//  FundRequests.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation

struct GetHomeDataRequest: APIRequest {
    typealias Response = HomeData
    let path = "get-home-data"
}

struct GetTopEarnersRequest: APIRequest {
    typealias Response = [AssetSummary]
    let path = "get-top-earnes"
}

struct GetFavoriteAssetsRequest: APIRequest {
    typealias Response = [FavoriteAsset]
    let path = "get-favorite-asset"
}

struct GetFundCategoriesRequest: APIRequest {
    typealias Response = [FundCategory]
    let path = "get-fund-category"
}

struct GetTopFundsRequest: APIRequest {
    typealias Response = [AssetSummary]
    let path = "get-top-funds"
    let type: TopFundType

    var parameters: [String: Any] { ["type": type.rawValue] }
}

struct SearchFundsRequest: APIRequest {
    typealias Response = [AssetSummary]
    let path = "search-fund"
    let query: String

    var parameters: [String: Any] { ["query": query] }
}
