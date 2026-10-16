//
//  CategoryItemCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

protocol CategoryItemCellViewModelDelegate: AnyObject {
    func categoryItemTapped(_ viewModel: CategoryItemCellViewModel)
}

final class CategoryItemCellViewModel: BaseCellViewModel {
    weak var actionDelegate: CategoryItemCellViewModelDelegate?

    let title: TextAttributes
    let value: TextAttributes
    var icon: ImageAttribute
    var arrowIcon = ImageAttribute(named: "CaretRight", tintColor: .gray30)

    init(title: String, value: String, iconName: String, isGain: Bool = true) {
        self.title = TextAttributes(text: title, style: .bodySmall, weight: .medium, color: .gray0)
        self.value = TextAttributes(text: value, style: .bodySmall, weight: .medium,
                                    color: isGain ? .success50 : .destructive50)
        icon = ImageAttribute(named: iconName, tintColor: .gray40)
        super.init()
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: AppConstants.Margin2x, right: 0)
    }

    override func clearViewModel() {
        super.clearViewModel()
        actionDelegate = nil
    }
}
