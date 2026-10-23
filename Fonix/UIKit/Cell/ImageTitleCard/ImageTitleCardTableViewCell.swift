//
//  ImageTitleCardTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 24.10.2026.
//

import Foundation
import UIKit

final class ImageTitleCardTableViewCell: BaseTableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardSubtitle: UILabel!
    @IBOutlet weak var arrowIcon: UIImageView!

    private var cardViewModel: ImageTitleCardCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = .clear
    }

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? ImageTitleCardCellViewModel else { return }
        cardViewModel = viewModel
        viewModel.title.apply(to: cardTitle)
        viewModel.subtitle.apply(to: cardSubtitle)
        viewModel.image.apply(to: cardImage)
        arrowIcon.isHidden = viewModel.arrowIcon.isEmpty
        viewModel.arrowIcon.apply(to: arrowIcon)
    }

    override func clearView() {
        super.clearView()
        cardViewModel = nil
    }

    @IBAction func cardTapped(_ sender: Any) {
        guard let cardViewModel else { return }
        containerView.bounce()
        cardViewModel.actionDelegate?.imageTitleCardTapped(cardViewModel)
    }
}
