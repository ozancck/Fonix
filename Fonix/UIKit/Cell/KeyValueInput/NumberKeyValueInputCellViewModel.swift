//
//  NumberKeyValueInputCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class NumberKeyValueInputCellViewModel: KeyValueInputCellViewModel {
    private(set) var decimalValue: Double?
    var unit: String
    var maxLength = 12
    let formatter: NumberFormatter

    init(title: String,
         value: Double? = nil,
         unit: String = "",
         fractionDigits: Int = 2,
         locale: Locale = Locale(identifier: "tr_TR")) {
        self.unit = unit
        formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = fractionDigits
        super.init(title: title)
        set(value: value)
    }

    var editableText: String {
        guard let decimalValue else { return "" }
        return formatter.string(from: NSNumber(value: decimalValue)) ?? ""
    }

    func set(value: Double?) {
        decimalValue = value
        guard let value else {
            text.text = ""
            return
        }
        let number = formatter.string(from: NSNumber(value: value)) ?? ""
        text.text = unit.isEmpty ? number : "\(number) \(unit)"
    }

    func commit(input: String) {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        let parsed = formatter.number(from: trimmed)?.doubleValue
            ?? Double(trimmed.replacingOccurrences(of: ",", with: "."))
        set(value: parsed)
    }

    override func validate() -> String? {
        guard isRequired, (decimalValue ?? 0) <= 0 else { return nil }
        return String(format: "required_field".localized, title.text)
    }
}
