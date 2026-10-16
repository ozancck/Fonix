//
//  TitleLabelCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class TitleLabelCellViewModel: BaseCellViewModel {
    let title: TextAttributes
    var containerBackgroundColor: UIColor = .clear
    var containerCornerRadius: CGFloat = 0
    var innerInset: UIEdgeInsets = .zero

    init(text: String,
         style: AppFont = .h4,
         weight: AppFontWeight = .bold,
         color: AppColor = .gray0,
         alignment: NSTextAlignment = .natural) {
        title = TextAttributes(text: text, style: style, weight: weight, color: color)
        title.alignment = alignment
        super.init()
        contentInset = UIEdgeInsets(top: AppConstants.Marginx, left: AppConstants.Margin2x,
                                    bottom: AppConstants.Marginx, right: AppConstants.Margin2x)
    }

    convenience init(detail: String, alignment: NSTextAlignment = .natural) {
        self.init(text: detail, style: .bodyMedium, weight: .regular, color: .gray30, alignment: alignment)
    }

    override func fixedHeight() -> CGFloat {
        let inset = contentInset ?? .zero
        let width = UIScreen.main.bounds.width - inset.left - inset.right - innerInset.left - innerInset.right
        let bounds = title.attributedString.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                                                         options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                         context: nil)
        return ceil(bounds.height) + inset.top + inset.bottom + innerInset.top + innerInset.bottom
    }
}
