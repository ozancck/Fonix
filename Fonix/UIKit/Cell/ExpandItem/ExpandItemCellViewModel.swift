//
//  ExpandItemCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

protocol ExpandItemCellViewModelDelegate: AnyObject {
    func expandCardItemTapped(_ viewModel: ExpandItemCellViewModel)
}

final class ExpandItemCellViewModel: BaseCellViewModel {
    weak var actionDelegate: ExpandItemCellViewModelDelegate?

    let title: TextAttributes
    let subtitle: TextAttributes
    let value: TextAttributes
    let ratio: TextAttributes
    let ratioIcon: ImageAttribute
    var arrowIcon = ImageAttribute(named: "CaretRight", tintColor: .gray60)

    init(title: String, subtitle: String, value: String, ratio: String, isGain: Bool) {
        self.title = TextAttributes(text: title, style: .bodyMedium, weight: .semibold, color: .gray0)
        self.subtitle = TextAttributes(text: subtitle, style: .bodySmall, weight: .regular, color: .gray30)
        self.value = TextAttributes(text: value, style: .bodyMedium, weight: .bold, color: .gray0)
        self.ratio = TextAttributes(text: ratio, style: .bodyMedium, weight: .medium,
                                    color: isGain ? .success50 : .destructive50)
        ratioIcon = ImageAttribute(named: isGain ? "CaretRatioUp" : "CaretRatioDown")
        super.init()
    }

    override func clearViewModel() {
        super.clearViewModel()
        actionDelegate = nil
    }
}
