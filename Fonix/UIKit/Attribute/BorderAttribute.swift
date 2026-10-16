//
//  BorderAttribute.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class BorderAttribute {
    var color: UIColor
    var activeColor: UIColor
    var width: CGFloat
    var cornerRadius: CGFloat

    init(color: AppColor = .gray60,
         activeColor: AppColor = .gray0,
         width: CGFloat = 1,
         cornerRadius: CGFloat = 12) {
        self.color = color.uiColor
        self.activeColor = activeColor.uiColor
        self.width = width
        self.cornerRadius = cornerRadius
    }

    func apply(to view: UIView, active: Bool = false) {
        view.layer.borderWidth = width
        view.layer.borderColor = (active ? activeColor : color).cgColor
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = cornerRadius > 0
    }
}
