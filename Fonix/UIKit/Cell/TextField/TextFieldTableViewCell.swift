//
//  TextFieldTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

class TextFieldTableViewCell: BaseTableViewCell, UITextFieldDelegate {
    let field = FloatingTextField()
    private var heightConstraint: NSLayoutConstraint!
    private(set) var textFieldViewModel: TextFieldCellViewModel?

    init() {
        super.init(style: .default, reuseIdentifier: nil)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(field)
        field.translatesAutoresizingMaskIntoConstraints = false

        heightConstraint = field.heightAnchor.constraint(equalToConstant: 56)
        let top = field.topAnchor.constraint(equalTo: contentView.topAnchor)
        let bottom = contentView.bottomAnchor.constraint(equalTo: field.bottomAnchor)
        let leading = field.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        let trailing = contentView.trailingAnchor.constraint(equalTo: field.trailingAnchor)
        bottom.priority = .defaultHigh
        NSLayoutConstraint.activate([heightConstraint, top, bottom, leading, trailing])
        topConstraint = top
        bottomConstraint = bottom
        leadingConstraint = leading
        trailingConstraint = trailing

        field.textField.delegate = self
        field.textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }

    required init?(coder: NSCoder) { nil }

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? TextFieldCellViewModel else { return }
        textFieldViewModel = viewModel

        field.configure(title: viewModel.floatingTitle,
                        placeholder: viewModel.placeholder,
                        text: viewModel.text,
                        backgroundColor: viewModel.fieldBackgroundColor)
        viewModel.border.apply(to: field, active: field.textField.isFirstResponder)
        field.textField.keyboardType = viewModel.inputType.keyboardType
        field.textField.isSecureTextEntry = viewModel.inputType.isSecure
        field.textField.textContentType = viewModel.textContentType
        field.textField.autocapitalizationType = viewModel.inputType == .email ? .none : .sentences
        heightConstraint.constant = viewModel.height
    }

    override func clearView() {
        super.clearView()
        textFieldViewModel = nil
    }

    @objc private func editingChanged() {
        guard let textFieldViewModel else { return }
        textFieldViewModel.text.text = field.text
        textFieldViewModel.inputDelegate?.textFieldDidUpdateValue(textFieldViewModel)
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textFieldViewModel else { return }
        textFieldViewModel.border.apply(to: field, active: true)
        textFieldViewModel.inputDelegate?.textFieldDidBeginEditing(textFieldViewModel)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textFieldViewModel else { return }
        textFieldViewModel.border.apply(to: field, active: false)
        textFieldViewModel.text.text = field.text
        textFieldViewModel.inputDelegate?.textFieldDidEndEditing(textFieldViewModel)
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let textFieldViewModel, textFieldViewModel.maxLength > 0,
              let current = textField.text, let swiftRange = Range(range, in: current) else { return true }
        let updated = current.replacingCharacters(in: swiftRange, with: string)
        return updated.count <= textFieldViewModel.maxLength
    }
}
