//
//  TabSegmentCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 24.10.2026.
//

import Foundation
import UIKit

protocol TabSegmentCellViewModelDelegate: AnyObject {
    func tabSegmentTapped(_ viewModel: TabSegmentCellViewModel)
}

/// Alt çizgili sekme öğesi. Seçili olan beyaz başlık + marka rengi çizgi, diğerleri gri.
final class TabSegmentItem {
    let identifier: String
    let normalTitle: TextAttributes
    let selectedTitle: TextAttributes
    var normalBarColor: UIColor = .clear
    var selectedBarColor: UIColor = AppColor.brand60.uiColor
    var selected = false

    init(identifier: String, title: String) {
        self.identifier = identifier
        normalTitle = TextAttributes(text: title, style: .bodyMedium, weight: .semibold, color: .gray50)
        selectedTitle = TextAttributes(text: title, style: .bodyMedium, weight: .semibold, color: .gray0)
    }

    var title: TextAttributes { selected ? selectedTitle : normalTitle }
    var barColor: UIColor { selected ? selectedBarColor : normalBarColor }
}

final class TabSegmentCellViewModel: BaseCellViewModel {
    weak var actionDelegate: TabSegmentCellViewModelDelegate?

    var items: [TabSegmentItem]
    private(set) var selectedIndex = -1

    init(items: [TabSegmentItem], selectedIndex: Int = 0) {
        self.items = items
        super.init()
        select(index: selectedIndex)
        contentInset = UIEdgeInsets(top: AppConstants.Marginx, left: 0, bottom: AppConstants.Marginx, right: 0)
    }

    var selectedItem: TabSegmentItem? {
        items.indices.contains(selectedIndex) ? items[selectedIndex] : nil
    }

    func select(index: Int) {
        guard items.indices.contains(index) else { return }
        selectedIndex = index
        for (offset, item) in items.enumerated() {
            item.selected = offset == index
        }
    }

    func select(identifier: String) {
        guard let index = items.firstIndex(where: { $0.identifier == identifier }) else { return }
        select(index: index)
    }

    override func clearViewModel() {
        super.clearViewModel()
        actionDelegate = nil
    }
}
