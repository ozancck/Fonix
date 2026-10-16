//
//  KeyValueInputTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class KeyValueInputTableViewCell: BaseTableViewCell, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    private let picker = UIPickerView()
    private let datePicker = UIDatePicker()
    private var keyValueViewModel: KeyValueInputCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        picker.dataSource = self
        picker.delegate = self
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        inputField.delegate = self
        inputField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        inputField.inputAccessoryView = UIToolbar.doneToolbar(target: self, action: #selector(doneTapped))
    }

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? KeyValueInputCellViewModel else { return }
        keyValueViewModel = viewModel

        viewModel.title.apply(to: titleLabel)
        showValue()

        iconContainerView.isHidden = viewModel.icon.isEmpty
        viewModel.icon.apply(to: iconImageView)
        rightImageView.isHidden = viewModel.rightIcon.isEmpty
        viewModel.rightIcon.apply(to: rightImageView)

        containerView.backgroundColor = viewModel.containerBackgroundColor
        viewModel.border.apply(to: containerView, active: inputField.isFirstResponder)
        heightConstraint.constant = viewModel.height
        configureInput(for: viewModel)
    }

    override func clearView() {
        super.clearView()
        keyValueViewModel = nil
    }

    func beginInput() {
        inputField.becomeFirstResponder()
    }

    @IBAction func actionButtonTapped(_ sender: UIButton) {
        beginInput()
    }

    private func showValue() {
        guard let keyValueViewModel else { return }
        let attributes = keyValueViewModel.hasValue ? keyValueViewModel.text : keyValueViewModel.placeholder
        attributes.apply(to: valueLabel)
    }

    private func configureInput(for viewModel: KeyValueInputCellViewModel) {
        inputField.inputView = nil
        inputField.keyboardType = .default
        switch viewModel {
        case let number as NumberKeyValueInputCellViewModel:
            inputField.keyboardType = .decimalPad
            inputField.text = number.editableText
        case let pickerViewModel as PickerKeyValueInputCellViewModel:
            inputField.inputView = picker
            picker.reloadAllComponents()
            if pickerViewModel.selectedIndex >= 0 {
                picker.selectRow(pickerViewModel.selectedIndex, inComponent: 0, animated: false)
            }
        case let dateViewModel as DateTimeKeyValueInputCellViewModel:
            datePicker.datePickerMode = dateViewModel.pickerMode
            datePicker.minimumDate = dateViewModel.minimumDate
            datePicker.maximumDate = dateViewModel.maximumDate
            datePicker.date = dateViewModel.date ?? Date()
            inputField.inputView = datePicker
        default:
            break
        }
    }

    private func notifyUpdate() {
        guard let keyValueViewModel else { return }
        showValue()
        keyValueViewModel.inputDelegate?.keyValueInputDidUpdateValue(keyValueViewModel)
    }

    @objc private func editingChanged() {
        guard let number = keyValueViewModel as? NumberKeyValueInputCellViewModel else { return }
        number.text.text = inputField.text ?? ""
        showValue()
    }

    @objc private func dateChanged() {
        guard let dateViewModel = keyValueViewModel as? DateTimeKeyValueInputCellViewModel else { return }
        dateViewModel.set(date: datePicker.date)
        showValue()
    }

    @objc private func doneTapped() {
        if let pickerViewModel = keyValueViewModel as? PickerKeyValueInputCellViewModel,
           pickerViewModel.selectedIndex < 0, !pickerViewModel.items.isEmpty {
            pickerViewModel.select(index: picker.selectedRow(inComponent: 0))
        }
        if let dateViewModel = keyValueViewModel as? DateTimeKeyValueInputCellViewModel, dateViewModel.date == nil {
            dateViewModel.set(date: datePicker.date)
        }
        endEditing(true)
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyValueViewModel?.border.apply(to: containerView, active: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let keyValueViewModel else { return }
        keyValueViewModel.border.apply(to: containerView, active: false)
        if let number = keyValueViewModel as? NumberKeyValueInputCellViewModel {
            number.commit(input: inputField.text ?? "")
            inputField.text = number.editableText
        }
        notifyUpdate()
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let number = keyValueViewModel as? NumberKeyValueInputCellViewModel,
              let current = textField.text, let swiftRange = Range(range, in: current) else { return false }
        let updated = current.replacingCharacters(in: swiftRange, with: string)
        let allowed = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: ",."))
        return updated.count <= number.maxLength && allowed.isSuperset(of: CharacterSet(charactersIn: updated))
    }

    // MARK: UIPickerView

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        (keyValueViewModel as? PickerKeyValueInputCellViewModel)?.items.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        (keyValueViewModel as? PickerKeyValueInputCellViewModel)?.items[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        (keyValueViewModel as? PickerKeyValueInputCellViewModel)?.select(index: row)
        showValue()
    }
}
