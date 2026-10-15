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
    let assetTypeIcon: String?
    let items: [UserAssetItem]

    var iconURL: URL? { assetTypeIcon.flatMap(URL.init) }
}

struct UserAssetItem: Decodable, Equatable {
    let productId: String
    let userId: String
    let assetCode: String
    let assetType: String
    let quantity: String
    let timestamp: String
    let assetImage: String?

    var quantityValue: Double? { Double(quantity) }
}
