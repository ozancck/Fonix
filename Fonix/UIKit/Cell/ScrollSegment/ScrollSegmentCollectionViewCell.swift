//
//  ScrollSegmentCollectionViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class ScrollSegmentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var segmentTitleLabel: UILabel!
    @IBOutlet weak var segmentImageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.clipsToBounds = false
        clipsToBounds = false
    }

    func set(item: ScrollSegmentItem) {
        let state = item.state
        state.title.apply(to: segmentTitleLabel)
        backgroundColorView.backgroundColor = state.backgroundColor
        backgroundColorView.layer.cornerRadius = state.cornerRadius
        backgroundColorView.layer.borderWidth = state.borderWidth
        backgroundColorView.layer.borderColor = state.borderColor.cgColor
        imageContainerView.isHidden = state.image.isEmpty
        state.image.apply(to: segmentImageView)
    }
}
