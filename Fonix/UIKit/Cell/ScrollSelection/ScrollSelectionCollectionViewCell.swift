//
//  ScrollSelectionCollectionViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class ScrollSelectionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var radioTitleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var checkContainerView: UIView!

    func set(item: ScrollSelectionItem, multiSelection: Bool) {
        let state = item.state
        state.title.apply(to: radioTitleLabel)
        containerView.backgroundColor = state.backgroundColor
        containerView.layer.cornerRadius = state.cornerRadius
        containerView.layer.borderWidth = state.borderWidth
        containerView.layer.borderColor = state.borderColor.cgColor
        checkContainerView.isHidden = false
        item.checkIcon(multiSelection: multiSelection).apply(to: checkImageView)
    }
}
