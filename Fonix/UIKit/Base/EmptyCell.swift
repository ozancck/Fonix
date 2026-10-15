//
//  EmptyCell.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

final class EmptyCellViewModel: BaseCellViewModel {
    var height: CGFloat

    init(height: CGFloat = AppConstants.Marginx) {
        self.height = height
        super.init()
    }

    override func makeCell() -> BaseTableViewCell? { EmptyTableViewCell() }
    override func fixedHeight() -> CGFloat { height }
}

final class EmptyTableViewCell: BaseTableViewCell {
    private var heightConstraint: NSLayoutConstraint?

    init() {
        super.init(style: .default, reuseIdentifier: nil)
        selectionStyle = .none
        backgroundColor = .clear
        heightConstraint = contentView.heightAnchor.constraint(equalToConstant: 1)
        heightConstraint?.priority = .defaultHigh
        heightConstraint?.isActive = true
    }

    required init?(coder: NSCoder) { nil }

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        heightConstraint?.constant = (viewModel as? EmptyCellViewModel)?.height ?? 1
    }
}
