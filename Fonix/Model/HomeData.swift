//
//  HomeData.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation

struct HomeData: Decodable, Equatable {
    let totalAmount: Double
    let userPortfolios: [Portfolio]
    let userAssets: [UserAsset]
}

struct Portfolio: Decodable, Equatable {
    let portfolioId: String
    let portfolioTitle: String
}

struct UserAsset: Decodable, Equatable {
    let assetType: String
    let totalAmount: Double
    let totalPercentage: Double
    let items: [UserAssetItem]
}

struct UserAssetItem: Decodable, Equatable {
    let productId: String
    let userId: String
    let assetCode: String
    let assetType: String
    let quantity: String
    let timestamp: String

    var quantityValue: Double? { Double(quantity) }
}
