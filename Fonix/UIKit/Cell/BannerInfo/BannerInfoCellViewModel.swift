//
//  BannerInfoCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

protocol BannerInfoCellViewModelDelegate: AnyObject {
    func bannerInfoTapped(_ viewModel: BannerInfoCellViewModel)
}

final class BannerInfoCellViewModel: BaseCellViewModel {
    weak var actionDelegate: BannerInfoCellViewModelDelegate?

    let title: TextAttributes
    let detail: TextAttributes
    var image = ImageAttribute(named: "Frame-2")
    let actionButton: ButtonAttribute

    init(title: String, detail: String, actionTitle: String) {
        self.title = TextAttributes(text: title, style: .h6, weight: .bold, color: .gray0)
        self.detail = TextAttributes(text: detail, style: .bodyXSmall, weight: .regular, color: .gray30)
        actionButton = ButtonAttribute(title: actionTitle, style: .bodySmall, weight: .semibold,
                                       titleColor: .brand60, backgroundColor: .brand90)
        actionButton.cornerRadius = 16
        actionButton.image = ImageAttribute(named: "Compass", tintColor: .brand60)
        super.init()
        contentInset = UIEdgeInsets(top: 0, left: AppConstants.Margin2x,
                                    bottom: AppConstants.Marginx, right: AppConstants.Margin2x)
    }

    override func clearViewModel() {
        super.clearViewModel()
        actionDelegate = nil
    }
}
