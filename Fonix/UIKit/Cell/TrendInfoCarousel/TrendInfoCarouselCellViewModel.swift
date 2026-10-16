//
//  TrendInfoCarouselCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

protocol TrendInfoCarouselCellViewModelDelegate: AnyObject {
    func trendInfoCardTapped(_ viewModel: TrendInfoCarouselCellViewModel, at index: Int)
}

final class TrendInfoCardItem {
    let title: TextAttributes
    let ratio: TextAttributes
    let value: TextAttributes
    var cardImage: ImageAttribute
    let trendIcon: ImageAttribute

    init(title: String, ratio: String, value: String, imageName: String = "CryptoLogo", isGain: Bool) {
        self.title = TextAttributes(text: title, style: .bodyLarge, weight: .bold, color: .gray0)
        self.ratio = TextAttributes(text: ratio, style: .bodyLarge, weight: .regular, color: .gray30)
        self.value = TextAttributes(text: value, style: .h5, weight: .semibold, color: .gray0)
        cardImage = ImageAttribute(named: imageName)
        trendIcon = ImageAttribute(named: isGain ? "TrendUp" : "TrendDown")
    }
}

final class TrendInfoCarouselCellViewModel: BaseCellViewModel {
    weak var actionDelegate: TrendInfoCarouselCellViewModelDelegate?

    var items: [TrendInfoCardItem]
    var lineSpacing: CGFloat = AppConstants.Margin2x
    var interitemSpacing: CGFloat = AppConstants.Margin2x
    var selectedIndex = 0

    init(items: [TrendInfoCardItem]) {
        self.items = items
        super.init()
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: AppConstants.Margin2x, right: 0)
    }

    override func clearViewModel() {
        super.clearViewModel()
        actionDelegate = nil
    }
}
