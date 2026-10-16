//
//  InfoCardCarouselCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

protocol InfoCardCarouselCellViewModelDelegate: AnyObject {
    func infoCardTapped(_ viewModel: InfoCardCarouselCellViewModel, at index: Int)
}

final class InfoCardCarouselItem {
    let title: TextAttributes
    let value: TextAttributes
    let ratio: TextAttributes
    let icon: ImageAttribute

    init(title: String, value: String, ratio: String, isGain: Bool) {
        self.title = TextAttributes(text: title, style: .bodySmall, weight: .semibold, color: .gray10)
        self.value = TextAttributes(text: value, style: .bodySmall, weight: .regular, color: .gray30)
        self.ratio = TextAttributes(text: ratio, style: .bodySmall, weight: .semibold,
                                    color: isGain ? .success50 : .destructive50)
        icon = ImageAttribute(named: isGain ? "CaretRatioUp" : "CaretRatioDown")
    }
}

final class InfoCardCarouselCellViewModel: BaseCellViewModel {
    weak var actionDelegate: InfoCardCarouselCellViewModelDelegate?

    var items: [InfoCardCarouselItem]
    var lineSpacing: CGFloat = AppConstants.Margin2x
    var interitemSpacing: CGFloat = AppConstants.Margin2x
    var selectedIndex = 0

    init(items: [InfoCardCarouselItem]) {
        self.items = items
        super.init()
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: AppConstants.Margin2x, right: 0)
    }

    override func clearViewModel() {
        super.clearViewModel()
        actionDelegate = nil
    }
}
