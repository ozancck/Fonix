//
//  ButtonAttribute.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

final class ButtonAttribute {
    var identifier = ""
    var title = TextAttributes()
    var image = ImageAttribute()
    var backgroundColor: UIColor = .clear
    var cornerRadius: CGFloat = 0
    var borderWidth: CGFloat = 0
    var borderColor: UIColor = .clear
    var bounceScale: CGFloat = AppConstants.BounceScale

    init(title: String = "",
         style: AppFont = .bodyLarge,
         weight: AppFontWeight = .semibold,
         titleColor: AppColor = .gray0,
         backgroundColor: AppColor? = nil) {
        self.title = TextAttributes(text: title, style: style, weight: weight, color: titleColor)
        self.backgroundColor = backgroundColor?.uiColor ?? .clear
    }

    func apply(to button: UIButton) {
        button.setAttributedTitle(title.attributedString, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = borderColor.cgColor
        if case .asset(let name) = image.source {
            button.setImage(AppImage.named(name)?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = image.tintColor ?? title.color
        }
    }
}
