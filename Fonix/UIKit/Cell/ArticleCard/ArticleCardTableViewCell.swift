//
//  ArticleCardTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class ArticleCardTableViewCell: BaseTableViewCell {
    @IBOutlet var containerView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var cardImageView: UIImageView!
    @IBOutlet var viewsIconImageView: UIImageView!
    @IBOutlet var viewsCountLabel: UILabel!
    @IBOutlet var likesIconImageView: UIImageView!
    @IBOutlet var likesCountLabel: UILabel!
    @IBOutlet var marketInfoContainer: UIView!
    @IBOutlet var marketInfoLabel: UILabel!
    @IBOutlet var marketInfoIconImageView: UIImageView!
    @IBOutlet var headerDot: UIImageView!
    @IBOutlet var footerDot: UIImageView!
    @IBOutlet var dotsThreeOutline: UIImageView!

    private var articleViewModel: ArticleCardCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = AppColor.gray80.uiColor
        marketInfoContainer.layer.cornerRadius = 12
        marketInfoContainer.layer.borderWidth = 1
        marketInfoContainer.layer.borderColor = AppColor.gray70.uiColor.cgColor
        marketInfoContainer.backgroundColor = .clear
    }

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? ArticleCardCellViewModel else { return }
        articleViewModel = viewModel

        viewModel.date.apply(to: dateLabel)
        viewModel.category.apply(to: categoryLabel)
        viewModel.title.apply(to: titleLabel)
        viewModel.detail.apply(to: descriptionLabel)
        viewModel.viewsCount.apply(to: viewsCountLabel)
        viewModel.likesCount.apply(to: likesCountLabel)
        viewModel.marketInfo.apply(to: marketInfoLabel)

        viewModel.image.apply(to: cardImageView)
        viewModel.viewsIcon.apply(to: viewsIconImageView)
        viewModel.likesIcon.apply(to: likesIconImageView)
        viewModel.headerDot.apply(to: headerDot)
        viewModel.footerDot.apply(to: footerDot)
        viewModel.moreIcon.apply(to: dotsThreeOutline)
        viewModel.marketInfoIcon.apply(to: marketInfoIconImageView)

        marketInfoContainer.isHidden = !viewModel.showMarketInfo
        containerView.layer.cornerRadius = viewModel.cornerRadius
    }

    override func clearView() {
        super.clearView()
        articleViewModel = nil
    }

    @IBAction func cardTapped(_ sender: UITapGestureRecognizer) {
        guard let articleViewModel else { return }
        containerView.bounce()
        articleViewModel.actionDelegate?.articleCardTapped(articleViewModel)
    }

    @IBAction func moreButtonTapped(_ sender: UIButton) {
        guard let articleViewModel else { return }
        articleViewModel.actionDelegate?.articleCardMoreTapped(articleViewModel)
    }
}
