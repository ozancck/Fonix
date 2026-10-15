//
//  SectionLabelCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

protocol SectionLabelCellViewModelDelegate: AnyObject {
    func sectionLabelActionTapped(_ viewModel: SectionLabelCellViewModel)
}

final class SectionLabelCellViewModel: BaseCellViewModel {
    weak var actionDelegate: SectionLabelCellViewModelDelegate?

    let title: TextAttributes
    var leftIcon = ImageAttribute()
    var actionButton: ButtonAttribute?
    var actionLeftIcon = ImageAttribute()

    init(title: String, actionTitle: String? = nil) {
        self.title = TextAttributes(text: title, style: .bodyLarge, weight: .bold, color: .gray0)
        if let actionTitle {
            actionButton = ButtonAttribute(title: actionTitle, style: .bodySmall, weight: .medium, titleColor: .brand60)
        }
        super.init()
        contentInset = UIEdgeInsets(top: AppConstants.Marginx, left: AppConstants.Margin2x,
                                    bottom: AppConstants.Marginx, right: AppConstants.Margin2x)
    }

    override func fixedHeight() -> CGFloat {
        (contentInset?.top ?? 0) + (contentInset?.bottom ?? 0) + title.font.pointSize
    }

    override func clearViewModel() {
        super.clearViewModel()
        actionDelegate = nil
    }
}
