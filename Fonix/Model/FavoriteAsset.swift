import Foundation

struct FavoriteAsset: Decodable, Equatable {
    let favoriteAssetId: String
    let userId: String
    let assetId: String
    let assetCode: String
    let assetType: String
    let assetTitle: String
    let assetLongTitle: String
    let assetSubTitle: String
    let assetPrice: String
    let assetRatio: String
    let assetImage: String?
    let detail: FundSummary?

    var summary: AssetSummary {
        AssetSummary(assetId: assetId,
                     assetCode: assetCode,
                     assetType: assetType,
                     assetTitle: assetTitle,
                     assetLongTitle: assetLongTitle,
                     assetSubTitle: assetSubTitle,
                     assetPrice: assetPrice,
                     assetRatio: assetRatio,
                     assetImage: assetImage)
    }
}

struct FundSummary: Decodable, Equatable {
    let fundId: String
    let fundCode: String
    let fundTitle: String
    let fundType: String
}
