//
//  TrendDetailCarouselCollectionViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class TrendDetailCarouselCollectionViewCell: UICollectionViewCell {
    @IBOutlet var containerView: UIView!
    @IBOutlet var cardImage: UIImageView!
    @IBOutlet var infoTitle: UILabel!
    @IBOutlet var infoRatio: UILabel!
    @IBOutlet var infoValue: UILabel!
    @IBOutlet var trendIcon: UIImageView!
    @IBOutlet var detailImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = AppColor.gray80.uiColor
        containerView.layer.cornerRadius = 16
    }

    func set(item: TrendDetailItem) {
        item.title.apply(to: infoTitle)
        item.ratio.apply(to: infoRatio)
        item.value.apply(to: infoValue)
        item.cardImage.apply(to: cardImage)
        item.trendIcon.apply(to: trendIcon)
        item.detailImage.apply(to: detailImage)
    }
}
