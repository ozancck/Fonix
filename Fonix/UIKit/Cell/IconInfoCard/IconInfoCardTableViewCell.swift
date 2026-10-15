//
//  IconInfoCardTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

final class IconInfoCardTableViewCell: BaseTableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardSubtitle: UILabel!
    @IBOutlet weak var cardValue: UILabel!
    @IBOutlet weak var cardRatioLabel: UILabel!
    @IBOutlet weak var ratioIcon: UIImageView!

    private var cardViewModel: IconInfoCardCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = .clear
    }


    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? IconInfoCardCellViewModel else { return }
        cardViewModel = viewModel
        viewModel.title.apply(to: cardTitle)
        viewModel.subtitle.apply(to: cardSubtitle)
        viewModel.value.apply(to: cardValue)
        viewModel.ratio.apply(to: cardRatioLabel)
        viewModel.image.apply(to: cardImage)
        viewModel.ratioIcon.apply(to: ratioIcon)
    }

    override func clearView() {
        super.clearView()
        cardViewModel = nil
    }

    @IBAction func cardTapped(_ sender: Any) {
        guard let cardViewModel else { return }
        containerView.bounce()
        cardViewModel.actionDelegate?.iconInfoCardTapped(cardViewModel)
    }
}
