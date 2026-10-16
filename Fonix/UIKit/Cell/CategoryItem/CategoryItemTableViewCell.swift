//
//  CategoryItemTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class CategoryItemTableViewCell: BaseTableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryDetailTitle: UILabel!
    @IBOutlet weak var arrowIcon: UIImageView!

    private var categoryViewModel: CategoryItemCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = AppColor.gray80.uiColor
        containerView.layer.cornerRadius = 16
    }

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? CategoryItemCellViewModel else { return }
        categoryViewModel = viewModel
        viewModel.title.apply(to: categoryTitle)
        viewModel.value.apply(to: categoryDetailTitle)
        viewModel.icon.apply(to: categoryIcon)
        viewModel.arrowIcon.apply(to: arrowIcon)
    }

    override func clearView() {
        super.clearView()
        categoryViewModel = nil
    }

    @IBAction func cardTapped(_ sender: Any) {
        guard let categoryViewModel else { return }
        containerView.bounce()
        categoryViewModel.actionDelegate?.categoryItemTapped(categoryViewModel)
    }
}
