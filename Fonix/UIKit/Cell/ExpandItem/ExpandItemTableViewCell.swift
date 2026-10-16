//
//  ExpandItemTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class ExpandItemTableViewCell: BaseTableViewCell {
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleText: UILabel!
    @IBOutlet var subtitleTText: UILabel!
    @IBOutlet var valueText: UILabel!
    @IBOutlet var ratioText: UILabel!
    @IBOutlet var ratioIcon: UIImageView!
    @IBOutlet var arrowIcon: UIImageView!

    private var itemViewModel: ExpandItemCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = AppColor.gray80.uiColor
        containerView.layer.cornerRadius = 24
    }

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? ExpandItemCellViewModel else { return }
        itemViewModel = viewModel
        viewModel.title.apply(to: titleText)
        viewModel.subtitle.apply(to: subtitleTText)
        viewModel.value.apply(to: valueText)
        viewModel.ratio.apply(to: ratioText)
        viewModel.ratioIcon.apply(to: ratioIcon)
        viewModel.arrowIcon.apply(to: arrowIcon)
    }

    override func clearView() {
        super.clearView()
        itemViewModel = nil
    }

    @IBAction func expandCardViewItemTapped(_ sender: Any) {
        guard let itemViewModel else { return }
        itemViewModel.actionDelegate?.expandCardItemTapped(itemViewModel)
    }
}
