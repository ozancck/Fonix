//
//  RecommendedTopicCollectionViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class RecommendedTopicCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var recommendedTitleLabel: UILabel!
    @IBOutlet weak var recommendedImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.backgroundColor = .clear
        borderView.layer.borderWidth = 2
        borderView.layer.borderColor = AppColor.brand60.uiColor.cgColor
        borderView.layer.cornerRadius = 24
        recommendedImageView.layer.borderWidth = 1
        recommendedImageView.layer.borderColor = AppColor.brand60.uiColor.cgColor
    }

    func set(item: RecommendedTopicItem) {
        item.title.apply(to: recommendedTitleLabel)
        item.image.apply(to: recommendedImageView)
    }
}
