//
//  IconInfoCardCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

protocol IconInfoCardCellViewModelDelegate: AnyObject {
    func iconInfoCardTapped(_ viewModel: IconInfoCardCellViewModel)
}

final class IconInfoCardCellViewModel: BaseCellViewModel {
    weak var actionDelegate: IconInfoCardCellViewModelDelegate?

    let title: TextAttributes
    let subtitle: TextAttributes
    let value: TextAttributes
    let ratio: TextAttributes
    var image = ImageAttribute(named: "CryptoLogo")
    private(set) var ratioIcon = ImageAttribute()
    /// Dokununca hangi varlığa gidileceğini taşır.
    let assetCode: String

    init(assetCode: String, title: String, subtitle: String, value: String, ratio: String, isGain: Bool) {
        self.assetCode = assetCode
        self.title = TextAttributes(text: title, style: .bodyLarge, weight: .semibold, color: .gray0)
        self.subtitle = TextAttributes(text: subtitle, style: .bodyXSmall, weight: .regular, color: .gray30)
        self.value = TextAttributes(text: value, style: .bodyLarge, weight: .regular, color: .gray30)
        self.ratio = TextAttributes(text: ratio, style: .bodySmall, weight: .medium, color: isGain ? .success50 : .destructive50)
        self.ratioIcon = ImageAttribute(named: isGain ? "CaretRatioUp" : "CaretRatioDown")
        super.init()
        contentInset = UIEdgeInsets(top: 0, left: AppConstants.Margin2x,
                                    bottom: AppConstants.Marginx, right: AppConstants.Margin2x)
    }

    override func clearViewModel() {
        super.clearViewModel()
        actionDelegate = nil
    }
}
