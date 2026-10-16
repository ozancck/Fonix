//
//  KeyValueInputCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

protocol KeyValueInputCellViewModelDelegate: AnyObject {
    func keyValueInputDidUpdateValue(_ viewModel: KeyValueInputCellViewModel)
}

class KeyValueInputCellViewModel: BaseCellViewModel {
    weak var inputDelegate: KeyValueInputCellViewModelDelegate?

    let title: TextAttributes
    let text: TextAttributes
    let placeholder: TextAttributes
    var icon = ImageAttribute()
    var rightIcon = ImageAttribute(named: "PencilSimpleLine", tintColor: .gray40)
    var border = BorderAttribute()
    var containerBackgroundColor: UIColor = AppColor.gray80.uiColor
    var isRequired = false
    var height: CGFloat = 56

    init(title: String, value: String = "", placeholder: String = "") {
        self.title = TextAttributes(text: title, style: .bodyLarge, weight: .medium, color: .gray30)
        text = TextAttributes(text: value, style: .bodyLarge, weight: .semibold, color: .gray0)
        self.placeholder = TextAttributes(text: placeholder, style: .bodyLarge, weight: .regular, color: .gray50)
        text.alignment = .right
        self.placeholder.alignment = .right
        super.init()
        contentInset = UIEdgeInsets(top: AppConstants.Marginx, left: AppConstants.Margin2x,
                                    bottom: AppConstants.Marginx, right: AppConstants.Margin2x)
    }

    var value: String { text.text }
    var hasValue: Bool { !text.text.isEmpty }

    override func cellIdentifier() -> String { "KeyValueInputTableViewCell" }

    override func fixedHeight() -> CGFloat {
        height + (contentInset?.top ?? 0) + (contentInset?.bottom ?? 0)
    }

    override func validate() -> String? {
        guard isRequired, !hasValue else { return nil }
        return String(format: "required_field".localized, title.text)
    }

    func focus() {
        (cell as? KeyValueInputTableViewCell)?.beginInput()
    }

    override func clearViewModel() {
        super.clearViewModel()
        inputDelegate = nil
    }
}
