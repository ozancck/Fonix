//
//  PickerTextFieldTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class PickerTextFieldTableViewCell: TextFieldTableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    private let picker = UIPickerView()
    private var pickerViewModel: PickerTextFieldCellViewModel?

    override init() {
        super.init()
        picker.dataSource = self
        picker.delegate = self
        field.textField.inputView = picker
        field.textField.inputAccessoryView = UIToolbar.doneToolbar(target: self, action: #selector(doneTapped))
        field.textField.tintColor = .clear
    }

    required init?(coder: NSCoder) { nil }

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? PickerTextFieldCellViewModel else { return }
        pickerViewModel = viewModel
        field.setRightIcon(viewModel.rightIcon)
        picker.reloadAllComponents()
        if viewModel.selectedIndex >= 0 {
            picker.selectRow(viewModel.selectedIndex, inComponent: 0, animated: false)
        }
    }

    override func clearView() {
        super.clearView()
        pickerViewModel = nil
    }

    override func textField(_ textField: UITextField,
                            shouldChangeCharactersIn range: NSRange,
                            replacementString string: String) -> Bool {
        false
    }

    private func choose(row: Int) {
        guard let pickerViewModel else { return }
        pickerViewModel.select(index: row)
        field.text = pickerViewModel.text.text
        pickerViewModel.inputDelegate?.textFieldDidUpdateValue(pickerViewModel)
    }

    @objc private func doneTapped() {
        if let pickerViewModel, pickerViewModel.selectedIndex < 0, !pickerViewModel.items.isEmpty {
            choose(row: picker.selectedRow(inComponent: 0))
        }
        endEditing(true)
    }

    // MARK: UIPickerView

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerViewModel?.items.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerViewModel?.items[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choose(row: row)
    }
}
