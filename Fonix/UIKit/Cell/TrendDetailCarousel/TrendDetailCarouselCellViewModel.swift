//
//  TrendDetailCarouselCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

protocol TrendDetailCarouselCellViewModelDelegate: AnyObject {
    func trendInfoDetailTapped(_ viewModel: TrendDetailCarouselCellViewModel, at index: Int)
}

final class TrendDetailItem {
    let title: TextAttributes
    let ratio: TextAttributes
    let value: TextAttributes
    var cardImage: ImageAttribute
    let trendIcon: ImageAttribute
    let detailImage: ImageAttribute

    init(title: String, ratio: String, value: String, imageName: String = "CryptoLogo", isGain: Bool) {
        self.title = TextAttributes(text: title, style: .bodyLarge, weight: .bold, color: .gray0)
        self.ratio = TextAttributes(text: ratio, style: .bodySmall, weight: .medium,
                                    color: isGain ? .success50 : .destructive50)
        self.value = TextAttributes(text: value, style: .bodyLarge, weight: .regular, color: .gray30)
        cardImage = ImageAttribute(named: imageName)
        trendIcon = ImageAttribute(named: isGain ? "CaretRatioUp" : "CaretRatioDown")
        detailImage = ImageAttribute(named: isGain ? "LineChartMini" : "RedLineChartMini")
    }
}

final class TrendDetailCarouselCellViewModel: BaseCellViewModel {
    weak var actionDelegate: TrendDetailCarouselCellViewModelDelegate?

    var items: [TrendDetailItem]
    var lineSpacing: CGFloat = AppConstants.Margin2x
    var interitemSpacing: CGFloat = AppConstants.Margin2x
    var selectedIndex = 0

    init(items: [TrendDetailItem]) {
        self.items = items
        super.init()
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: AppConstants.Margin2x, right: 0)
    }

    override func clearViewModel() {
        super.clearViewModel()
        actionDelegate = nil
    }
}
