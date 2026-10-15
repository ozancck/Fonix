import Foundation

struct AssetSummary: Decodable, Equatable {
    let assetId: String
    let assetCode: String
    let assetType: String
    let assetTitle: String
    let assetLongTitle: String
    let assetSubTitle: String
    let assetPrice: String
    let assetRatio: String
    let assetImage: String?

    var price: Double? { Double(assetPrice) }
    var ratio: Double? { Double(assetRatio) }
    var isGain: Bool { (ratio ?? 0) >= 0 }
    var imageURL: URL? { assetImage.flatMap(URL.init) }
}
