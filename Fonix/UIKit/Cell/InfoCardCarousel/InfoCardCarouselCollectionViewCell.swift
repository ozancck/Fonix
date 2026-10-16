//
//  InfoCardCarouselCollectionViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class InfoCardCarouselCollectionViewCell: UICollectionViewCell {
    @IBOutlet var containerView: UIView!
    @IBOutlet var infoTitleLabel: UILabel!
    @IBOutlet var infoRatioLabel: UILabel!
    @IBOutlet var infoValueLabel: UILabel!
    @IBOutlet var infoIconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = AppColor.gray80.uiColor
        containerView.layer.cornerRadius = 16
    }

    func set(item: InfoCardCarouselItem) {
        item.title.apply(to: infoTitleLabel)
        item.ratio.apply(to: infoRatioLabel)
        item.value.apply(to: infoValueLabel)
        item.icon.apply(to: infoIconImageView)
    }
}
