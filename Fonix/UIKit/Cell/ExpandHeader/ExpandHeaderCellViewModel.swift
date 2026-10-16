//
//  ExpandHeaderCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

protocol ExpandHeaderCellViewModelDelegate: AnyObject {
    func expandCardHeaderTapped(_ viewModel: ExpandHeaderCellViewModel)
}

final class ExpandHeaderCellViewModel: BaseCellViewModel {
    weak var actionDelegate: ExpandHeaderCellViewModelDelegate?

    let title: TextAttributes
    let subtitle: TextAttributes
    let value: TextAttributes
    var icon: ImageAttribute
    private(set) var isExpanded: Bool

    init(title: String,
         subtitle: String,
         value: String,
         iconName: String,
         iconColor: AppColor = .gray30,
         isExpanded: Bool = false) {
        self.title = TextAttributes(text: title, style: .bodyMedium, weight: .semibold, color: .gray0)
        self.subtitle = TextAttributes(text: subtitle, style: .bodySmall, weight: .regular, color: .gray30)
        self.value = TextAttributes(text: value, style: .bodyMedium, weight: .semibold, color: .gray0)
        icon = ImageAttribute(named: iconName, tintColor: iconColor)
        self.isExpanded = isExpanded
        super.init()
    }

    var arrowIcon: ImageAttribute {
        ImageAttribute(named: isExpanded ? "CaretUp" : "CaretDown", tintColor: .gray30)
    }

    func toggle() {
        isExpanded.toggle()
    }

    override func clearViewModel() {
        super.clearViewModel()
        actionDelegate = nil
    }
}
