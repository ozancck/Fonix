//
//  AssetSummary.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation

/// get-top-earnes, get-top-funds, get-asset-products, search-fund ve
/// get-favorite-asset'in ortak satır şekli. Fiyat ve getiri mock'ta string gelir.
struct AssetSummary: Decodable, Equatable {
    let assetId: String
    let assetCode: String
    let assetType: String
    let assetTitle: String
    let assetLongTitle: String
    let assetSubTitle: String
    let assetPrice: String
    let assetRatio: String

    var price: Double? { Double(assetPrice) }
    var ratio: Double? { Double(assetRatio) }
    var isGain: Bool { (ratio ?? 0) >= 0 }
}
