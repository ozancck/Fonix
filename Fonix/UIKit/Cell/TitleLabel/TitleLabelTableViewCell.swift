//
//  TitleLabelTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class TitleLabelTableViewCell: BaseTableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var innerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerTrailingConstraint: NSLayoutConstraint!

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? TitleLabelCellViewModel else { return }

        viewModel.title.apply(to: titleLabel)
        containerView.backgroundColor = viewModel.containerBackgroundColor
        containerView.layer.cornerRadius = viewModel.containerCornerRadius

        innerTopConstraint.constant = viewModel.innerInset.top
        innerBottomConstraint.constant = viewModel.innerInset.bottom
        innerLeadingConstraint.constant = viewModel.innerInset.left
        innerTrailingConstraint.constant = viewModel.innerInset.right
    }
}
