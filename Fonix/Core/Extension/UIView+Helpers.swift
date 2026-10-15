//
//  UIView+Helpers.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

extension UIView {
    private static let separatorTag = 1100

    func removeSeparator() {
        viewWithTag(Self.separatorTag)?.removeFromSuperview()
    }

    func addSeparator(color: UIColor, inset: UIEdgeInsets) {
        removeSeparator()
        let line = UIView()
        line.tag = Self.separatorTag
        line.backgroundColor = color
        line.translatesAutoresizingMaskIntoConstraints = false
        addSubview(line)
        NSLayoutConstraint.activate([
            line.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.left),
            line.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset.right),
            line.bottomAnchor.constraint(equalTo: bottomAnchor),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    func bounce(scale: CGFloat = AppConstants.BounceScale) {
        transform = CGAffineTransform(scaleX: scale, y: scale)
        UIView.animate(withDuration: 1.0, delay: 0,
                       usingSpringWithDamping: 0.2, initialSpringVelocity: 6,
                       options: .allowUserInteraction) { [weak self] in
            self?.transform = .identity
        }
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        for view in arrangedSubviews {
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
