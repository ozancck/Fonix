//
//  SectionLabelTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

final class SectionLabelTableViewCell: BaseTableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionButtonContainerView: UIView!
    @IBOutlet weak var actionButtonStackView: UIStackView!
    @IBOutlet weak var actionButtonLeftIconImageView: UIImageView!
    @IBOutlet weak var actionButtonLeftIconContainerView: UIView!
    @IBOutlet weak var actionButtonTitleLabel: UILabel!
    @IBOutlet weak var actionButtonTitleContainerView: UIView!
    @IBOutlet weak var actionButtonRightIconImageView: UIImageView!
    @IBOutlet weak var actionButtonRightIconContainerView: UIView!
    @IBOutlet weak var sectionLeftIconContainerView: UIView!
    @IBOutlet weak var sectionLeftIconImageView: UIImageView!
    @IBOutlet weak var sectionTitleLabel: UILabel!

    private var sectionViewModel: SectionLabelCellViewModel?

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? SectionLabelCellViewModel else { return }
        sectionViewModel = viewModel

        viewModel.title.apply(to: sectionTitleLabel)

        sectionLeftIconContainerView.isHidden = viewModel.leftIcon.isEmpty
        viewModel.leftIcon.apply(to: sectionLeftIconImageView)

        guard let action = viewModel.actionButton else {
            actionButtonContainerView.isHidden = true
            return
        }
        actionButtonContainerView.isHidden = false
        action.title.apply(to: actionButtonTitleLabel)

        actionButtonRightIconContainerView.isHidden = action.image.isEmpty
        action.image.apply(to: actionButtonRightIconImageView)

        actionButtonLeftIconContainerView.isHidden = viewModel.actionLeftIcon.isEmpty
        viewModel.actionLeftIcon.apply(to: actionButtonLeftIconImageView)
    }

    override func clearView() {
        super.clearView()
        sectionViewModel = nil
    }

    @IBAction func actionButtonTapped(_ sender: UIButton) {
        guard let sectionViewModel else { return }
        actionButtonContainerView.bounce(scale: sectionViewModel.actionButton?.bounceScale ?? AppConstants.BounceScale)
        sectionViewModel.actionDelegate?.sectionLabelActionTapped(sectionViewModel)
    }
}
