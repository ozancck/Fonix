//
//  TextAttributes.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

final class TextAttributes {
    var text = ""
    var font: UIFont = AppFont.bodyMedium.attributes().font
    var lineHeight: CGFloat = AppFont.bodyMedium.lineHeight
    var color: UIColor = AppColor.gray0.uiColor
    var alignment: NSTextAlignment = .natural

    init(text: String = "",
         style: AppFont = .bodyMedium,
         weight: AppFontWeight = .regular,
         color: AppColor = .gray0) {
        self.text = text
        self.color = color.uiColor
        set(style.attributes(weight))
    }

    func set(_ attributes: FontAttributes) {
        font = attributes.font
        lineHeight = attributes.lineHeight
    }

    var attributedString: NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.minimumLineHeight = lineHeight
        paragraph.maximumLineHeight = lineHeight
        paragraph.alignment = alignment
        return NSAttributedString(string: text, attributes: [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraph
        ])
    }

    func apply(to label: UILabel) {
        label.attributedText = attributedString
    }
}
