//
//  ButtonCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

protocol ButtonCellViewModelDelegate: AnyObject {
    func buttonTapped(_ viewModel: ButtonCellViewModel)
}

final class ButtonCellViewModel: BaseCellViewModel {
    weak var actionDelegate: ButtonCellViewModelDelegate?
    let button: ButtonAttribute
    var height: CGFloat = 40

    init(title: String, iconName: String? = nil) {
        button = ButtonAttribute(title: title, style: .bodyMedium, weight: .semibold,
                                 titleColor: .gray0, backgroundColor: .brand60)
        button.cornerRadius = 18
        if let iconName { button.image = ImageAttribute(named: iconName, tintColor: .gray0) }
        super.init()
        contentInset = UIEdgeInsets(top: AppConstants.Margin2x, left: AppConstants.Margin2x,
                                    bottom: AppConstants.Margin2x, right: AppConstants.Margin2x)
    }

    override func makeCell() -> BaseTableViewCell? { ButtonTableViewCell() }

    override func fixedHeight() -> CGFloat {
        height + (contentInset?.top ?? 0) + (contentInset?.bottom ?? 0)
    }

    override func clearViewModel() {
        super.clearViewModel()
        actionDelegate = nil
    }
}
