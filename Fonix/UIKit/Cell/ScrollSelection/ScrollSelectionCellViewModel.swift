//
//  ScrollSelectionCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

protocol ScrollSelectionCellViewModelDelegate: AnyObject {
    func scrollSelectionChanged(_ viewModel: ScrollSelectionCellViewModel)
}

final class ScrollSelectionItem {
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

    func checkIcon(multiSelection: Bool) -> ImageAttribute {
        let name: String
        switch (multiSelection, selected) {
        case (true, true): name = "checkmark.square.fill"
        case (true, false): name = "square"
        case (false, true): name = "checkmark.circle.fill"
        case (false, false): name = "circle"
        }
        return ImageAttribute(systemName: name, tintColor: selected ? .brand60 : .gray30)
    }
}

final class ScrollSelectionCellViewModel: BaseCellViewModel {
    weak var actionDelegate: ScrollSelectionCellViewModelDelegate?

    var items: [ScrollSelectionItem]
    var multiSelection: Bool
    var isRequired = false

    init(items: [ScrollSelectionItem], multiSelection: Bool = false) {
        self.items = items
        self.multiSelection = multiSelection
        super.init()
        contentInset = UIEdgeInsets(top: AppConstants.Marginx, left: 0, bottom: AppConstants.Marginx, right: 0)
    }

    var selectedItems: [ScrollSelectionItem] { items.filter { $0.selected } }
    var selectedItem: ScrollSelectionItem? { selectedItems.first }

    func toggle(index: Int) {
        guard items.indices.contains(index) else { return }
        if multiSelection {
            items[index].selected.toggle()
        } else {
            for (offset, item) in items.enumerated() {
                item.selected = offset == index
            }
        }
    }

    override func validate() -> String? {
        guard isRequired, selectedItems.isEmpty else { return nil }
        return "selection_required".localized
    }

    override func clearViewModel() {
        super.clearViewModel()
        actionDelegate = nil
    }
}
