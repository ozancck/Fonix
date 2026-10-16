//
//  TextFieldCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

protocol TextFieldCellViewModelDelegate: AnyObject {
    func textFieldDidUpdateValue(_ viewModel: TextFieldCellViewModel)
    func textFieldDidBeginEditing(_ viewModel: TextFieldCellViewModel)
    func textFieldDidEndEditing(_ viewModel: TextFieldCellViewModel)
}

extension TextFieldCellViewModelDelegate {
    func textFieldDidUpdateValue(_ viewModel: TextFieldCellViewModel) {}
    func textFieldDidBeginEditing(_ viewModel: TextFieldCellViewModel) {}
    func textFieldDidEndEditing(_ viewModel: TextFieldCellViewModel) {}
}

enum TextInputType {
    case text, email, number, decimal, password, phone

    var keyboardType: UIKeyboardType {
        switch self {
        case .text, .password: return .default
        case .email: return .emailAddress
        case .number: return .numberPad
        case .decimal: return .decimalPad
        case .phone: return .phonePad
        }
    }

    var isSecure: Bool { self == .password }
}

class TextFieldCellViewModel: BaseCellViewModel {
    weak var inputDelegate: TextFieldCellViewModelDelegate?

    let floatingTitle: TextAttributes
    let placeholder: TextAttributes
    let text: TextAttributes
    var border = BorderAttribute()
    var fieldBackgroundColor: UIColor = AppColor.gray80.uiColor
    var inputType: TextInputType
    var textContentType: UITextContentType?
    var maxLength = 0
    var isRequired = false
    var height: CGFloat = 56

    init(title: String,
         placeholder: String? = nil,
         value: String = "",
         inputType: TextInputType = .text) {
        floatingTitle = TextAttributes(text: title, style: .bodyXSmall, weight: .semibold, color: .gray30)
        self.placeholder = TextAttributes(text: placeholder ?? title, style: .bodyLarge, weight: .regular, color: .gray50)
        text = TextAttributes(text: value, style: .bodyLarge, weight: .semibold, color: .gray0)
        self.inputType = inputType
        super.init()
        contentInset = UIEdgeInsets(top: AppConstants.Marginx, left: AppConstants.Margin2x,
                                    bottom: AppConstants.Marginx, right: AppConstants.Margin2x)
    }

    var value: String { text.text.trimmingCharacters(in: .whitespacesAndNewlines) }

    override func makeCell() -> BaseTableViewCell? { TextFieldTableViewCell() }

    override func fixedHeight() -> CGFloat {
        height + (contentInset?.top ?? 0) + (contentInset?.bottom ?? 0)
    }

    override func validate() -> String? {
        if isRequired && value.isEmpty {
            return String(format: "required_field".localized, floatingTitle.text)
        }
        if inputType == .email && !value.isEmpty && !value.isValidEmail {
            return "invalid_email".localized
        }
        return nil
    }

    func focus() {
        (cell as? TextFieldTableViewCell)?.field.textField.becomeFirstResponder()
    }

    override func clearViewModel() {
        super.clearViewModel()
        inputDelegate = nil
    }
}

extension String {
    var isValidEmail: Bool {
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return range(of: pattern, options: .regularExpression) != nil
    }
}
