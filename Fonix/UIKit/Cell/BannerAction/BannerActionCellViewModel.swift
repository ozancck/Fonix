//
//  BannerActionCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

protocol BannerActionCellViewModelDelegate: AnyObject {
    func bannerActionTapped(_ viewModel: BannerActionCellViewModel)
}

final class BannerActionCellViewModel: BaseCellViewModel {
    weak var actionDelegate: BannerActionCellViewModelDelegate?

    let title: TextAttributes
    let detail: TextAttributes
    var image: ImageAttribute
    let actionButton: ButtonAttribute

    init(title: String, detail: String, actionTitle: String, imageName: String = "AI-Analyzed_Investment_Risks_2_") {
        self.title = TextAttributes(text: title, style: .bodyLarge, weight: .bold, color: .gray0)
        self.detail = TextAttributes(text: detail, style: .bodySmall, weight: .regular, color: .gray30)
        image = ImageAttribute(named: imageName)
        actionButton = ButtonAttribute(title: actionTitle, style: .bodySmall, weight: .semibold,
                                       titleColor: .gray0, backgroundColor: .brand60)
        actionButton.cornerRadius = 16
        actionButton.image = ImageAttribute(named: "ArrowRight", tintColor: .gray0)
        super.init()
        contentInset = UIEdgeInsets(top: 0, left: AppConstants.Margin2x,
                                    bottom: AppConstants.Marginx, right: AppConstants.Margin2x)
    }

    override func clearViewModel() {
        super.clearViewModel()
        actionDelegate = nil
    }
}
