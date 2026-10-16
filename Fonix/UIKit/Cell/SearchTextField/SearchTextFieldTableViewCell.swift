//
//  SearchTextFieldTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class SearchTextFieldTableViewCell: BaseTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    private var searchViewModel: SearchTextFieldCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        searchTextField.delegate = self
        searchTextField.borderStyle = .none
        searchTextField.autocorrectionType = .no
        searchTextField.returnKeyType = .search
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? SearchTextFieldCellViewModel else { return }
        searchViewModel = viewModel

        containerView.backgroundColor = viewModel.containerBackgroundColor
        containerView.layer.cornerRadius = viewModel.cornerRadius
        heightConstraint.constant = viewModel.height

        iconImageView.isHidden = viewModel.icon.isEmpty
        viewModel.icon.apply(to: iconImageView)

        searchTextField.font = viewModel.text.font
        searchTextField.textColor = viewModel.text.color
        searchTextField.tintColor = viewModel.text.color
        searchTextField.text = viewModel.text.text
        searchTextField.attributedPlaceholder = viewModel.placeholder.attributedString
    }

    override func clearView() {
        super.clearView()
        searchViewModel = nil
    }

    func clearInput() {
        searchTextField.text = ""
    }

    @objc private func textChanged() {
        guard let searchViewModel else { return }
        searchViewModel.text.text = searchTextField.text ?? ""
        searchViewModel.searchDelegate?.searchTextDidChange(searchViewModel)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}
