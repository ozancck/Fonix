//
//  TabSegmentCollectionViewCell.swift
//  Fonix
//
//  Created by Ozan on 24.10.2026.
//

import Foundation
import UIKit

final class TabSegmentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomBarView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.clipsToBounds = false
        clipsToBounds = false
        containerView.backgroundColor = .clear
        bottomBarView.layer.cornerRadius = 1
    }

    func set(item: TabSegmentItem) {
        item.title.apply(to: titleLabel)
        bottomBarView.backgroundColor = item.barColor
    }
}
