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
