//
//  BannerActionTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class BannerActionTableViewCell: BaseTableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bannerTitleLabel: UILabel!
    @IBOutlet weak var bannerDetailLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!

    private var bannerViewModel: BannerActionCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = AppColor.gray80.uiColor
        containerView.layer.cornerRadius = 24
    }

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? BannerActionCellViewModel else { return }
        bannerViewModel = viewModel
        viewModel.title.apply(to: bannerTitleLabel)
        viewModel.detail.apply(to: bannerDetailLabel)
        viewModel.actionButton.apply(to: actionButton)
        actionButton.semanticContentAttribute = .forceRightToLeft
        viewModel.image.apply(to: bannerImageView)
    }

    override func clearView() {
        super.clearView()
        bannerViewModel = nil
    }

    @IBAction func actionButtonTapped(_ sender: UIButton) {
        guard let bannerViewModel else { return }
        containerView.bounce(scale: bannerViewModel.actionButton.bounceScale)
        bannerViewModel.actionDelegate?.bannerActionTapped(bannerViewModel)
    }
}
