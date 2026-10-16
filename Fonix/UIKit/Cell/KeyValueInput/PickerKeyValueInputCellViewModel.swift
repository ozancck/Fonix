//
//  PickerKeyValueInputCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class PickerKeyValueInputCellViewModel: KeyValueInputCellViewModel {
    var items: [String]
    private(set) var selectedIndex = -1

    init(title: String, items: [String], selectedIndex: Int = -1) {
        self.items = items
        super.init(title: title, placeholder: "select".localized)
        rightIcon = ImageAttribute(named: "CaretDown", tintColor: .gray40)
        select(index: selectedIndex)
    }

    var selectedValue: String? {
        items.indices.contains(selectedIndex) ? items[selectedIndex] : nil
    }

    func select(index: Int) {
        guard items.indices.contains(index) else {
            selectedIndex = -1
            text.text = ""
            return
        }
        selectedIndex = index
        text.text = items[index]
    }

    override func validate() -> String? {
        guard isRequired, selectedValue == nil else { return nil }
        return String(format: "required_field".localized, title.text)
    }
}
