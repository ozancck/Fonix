//
//  ScrollSegmentCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

protocol ScrollSegmentCellViewModelDelegate: AnyObject {
    func scrollSegmentTapped(_ viewModel: ScrollSegmentCellViewModel)
}

final class ScrollSegmentItem {
    let identifier: String
    let normalState: ButtonAttribute
    let selectedState: ButtonAttribute
    var selected = false

    init(identifier: String, title: String, iconName: String? = nil) {
        self.identifier = identifier
        normalState = ScrollSegmentItem.chip(title: title, iconName: iconName,
                                             color: .gray30, background: .gray90, border: .gray70)
        selectedState = ScrollSegmentItem.chip(title: title, iconName: iconName,
                                               color: .brand60, background: .brand90, border: .brand60)
    }

    var state: ButtonAttribute { selected ? selectedState : normalState }

    static func chip(title: String, iconName: String?, color: AppColor, background: AppColor, border: AppColor) -> ButtonAttribute {
        let attribute = ButtonAttribute(title: title, style: .bodySmall, weight: .semibold,
                                        titleColor: color, backgroundColor: background)
        attribute.cornerRadius = 20
        attribute.borderWidth = 1
        attribute.borderColor = border.uiColor
        if let iconName { attribute.image = ImageAttribute(named: iconName, tintColor: color) }
        return attribute
    }
}

final class ScrollSegmentCellViewModel: BaseCellViewModel {
    weak var actionDelegate: ScrollSegmentCellViewModelDelegate?

    var items: [ScrollSegmentItem]
    private(set) var selectedIndex = -1

    init(items: [ScrollSegmentItem], selectedIndex: Int = 0) {
        self.items = items
        super.init()
        select(index: selectedIndex)
        contentInset = UIEdgeInsets(top: AppConstants.Marginx, left: 0, bottom: AppConstants.Marginx, right: 0)
    }

    var selectedItem: ScrollSegmentItem? {
        items.indices.contains(selectedIndex) ? items[selectedIndex] : nil
    }

    func select(index: Int) {
        guard items.indices.contains(index) else { return }
        selectedIndex = index
        for (offset, item) in items.enumerated() {
            item.selected = offset == index
        }
    }

    override func clearViewModel() {
        super.clearViewModel()
        actionDelegate = nil
    }
}
