//
//  BannerInfoTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

final class BannerInfoTableViewCell: BaseTableViewCell {
    @IBOutlet var bannerTitleLabel: UILabel!
    @IBOutlet var bannerDetailLabel: UILabel!
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var bannerImage: UIImageView!
    @IBOutlet var containerView: UIView!

    private var bannerViewModel: BannerInfoCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = AppColor.gray80.uiColor
        containerView.layer.cornerRadius = 24
    }

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? BannerInfoCellViewModel else { return }
        bannerViewModel = viewModel
        viewModel.title.apply(to: bannerTitleLabel)
        viewModel.detail.apply(to: bannerDetailLabel)
        viewModel.actionButton.apply(to: actionButton)
        viewModel.image.apply(to: bannerImage)
    }

    override func clearView() {
        super.clearView()
        bannerViewModel = nil
    }

    @IBAction func cardTapped(_ sender: Any) {
        guard let bannerViewModel else { return }
        containerView.bounce()
        bannerViewModel.actionDelegate?.bannerInfoTapped(bannerViewModel)
    }
}
