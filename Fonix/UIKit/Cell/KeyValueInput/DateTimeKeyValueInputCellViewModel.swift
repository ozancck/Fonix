//
//  DateTimeKeyValueInputCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class DateTimeKeyValueInputCellViewModel: KeyValueInputCellViewModel {
    private(set) var date: Date?
    var minimumDate: Date?
    var maximumDate: Date?
    var pickerMode: UIDatePicker.Mode
    let formatter: DateFormatter

    init(title: String,
         date: Date? = nil,
         mode: UIDatePicker.Mode = .date,
         format: String = "dd.MM.yyyy",
         locale: Locale = Locale(identifier: "tr_TR")) {
        pickerMode = mode
        formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = format
        super.init(title: title, placeholder: "select".localized)
        set(date: date)
    }

    func set(date: Date?) {
        self.date = date
        text.text = date.map { formatter.string(from: $0) } ?? ""
    }

    override func validate() -> String? {
        guard isRequired, date == nil else { return nil }
        return String(format: "required_field".localized, title.text)
    }
}
