//
//  BaseTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

class BaseTableViewCell: UITableViewCell {
    private(set) var viewModel: BaseCellViewModel?
    var indexPath: IndexPath?

    @IBOutlet weak var topConstraint: NSLayoutConstraint?
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint?
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        clipsToBounds = false
        contentView.clipsToBounds = false
    }

    func set(viewModel: BaseCellViewModel) {
        self.viewModel = viewModel
        backgroundColor = viewModel.backgroundColor
        contentView.alpha = viewModel.disabled ? 0.4 : 1.0
        isUserInteractionEnabled = !viewModel.disabled

        if let separator = viewModel.separator {
            contentView.addSeparator(color: separator.color, inset: separator.inset)
        } else {
            contentView.removeSeparator()
        }

        if let inset = viewModel.contentInset {
            topConstraint?.constant = inset.top
            bottomConstraint?.constant = inset.bottom
            leadingConstraint?.constant = inset.left
            trailingConstraint?.constant = inset.right
        }
    }

    func cellWillAppear() {}
    func cellWillDisappear() {}
    func cellWillDisplay() {}
    func cellDidEndDisplaying() {}

    func clearView() { viewModel = nil }

    deinit { AppLog.deinitialize(self) }
}
