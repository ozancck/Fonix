//
//  ExpandHeaderTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class ExpandHeaderTableViewCell: BaseTableViewCell {
    @IBOutlet var containerView: UIView!
    @IBOutlet var cardIcon: UIImageView!
    @IBOutlet var arrowIcon: UIImageView!
    @IBOutlet var titleText: UILabel!
    @IBOutlet var subtitleText: UILabel!
    @IBOutlet var valueText: UILabel!

    private var headerViewModel: ExpandHeaderCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = AppColor.gray80.uiColor
        containerView.layer.cornerRadius = 24
    }

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? ExpandHeaderCellViewModel else { return }
        headerViewModel = viewModel
        viewModel.title.apply(to: titleText)
        viewModel.subtitle.apply(to: subtitleText)
        viewModel.value.apply(to: valueText)
        viewModel.icon.apply(to: cardIcon)
        viewModel.arrowIcon.apply(to: arrowIcon)
    }

    override func clearView() {
        super.clearView()
        headerViewModel = nil
    }

    @IBAction func expandCardTapped(_ sender: Any) {
        guard let headerViewModel else { return }
        headerViewModel.toggle()
        headerViewModel.arrowIcon.apply(to: arrowIcon)
        headerViewModel.actionDelegate?.expandCardHeaderTapped(headerViewModel)
    }
}
