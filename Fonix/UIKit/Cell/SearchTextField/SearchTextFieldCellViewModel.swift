//
//  SearchTextFieldCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

protocol SearchTextFieldCellViewModelDelegate: AnyObject {
    func searchTextDidChange(_ viewModel: SearchTextFieldCellViewModel)
}

final class SearchTextFieldCellViewModel: BaseCellViewModel {
    weak var searchDelegate: SearchTextFieldCellViewModelDelegate?

    let placeholder: TextAttributes
    let text: TextAttributes
    var icon = ImageAttribute(named: "MagnifyingGlass", tintColor: .gray30)
    var containerBackgroundColor: UIColor = AppColor.gray80.uiColor
    var cornerRadius: CGFloat = 24
    var height: CGFloat = 48

    init(placeholder: String, value: String = "") {
        self.placeholder = TextAttributes(text: placeholder, style: .bodyMedium, weight: .regular, color: .gray50)
        text = TextAttributes(text: value, style: .bodyMedium, weight: .medium, color: .gray0)
        super.init()
        contentInset = UIEdgeInsets(top: AppConstants.Marginx, left: AppConstants.Margin2x,
                                    bottom: AppConstants.Marginx, right: AppConstants.Margin2x)
    }

    var value: String { text.text.trimmingCharacters(in: .whitespacesAndNewlines) }

    override func fixedHeight() -> CGFloat {
        height + (contentInset?.top ?? 0) + (contentInset?.bottom ?? 0)
    }

    func clear() {
        text.text = ""
        (cell as? SearchTextFieldTableViewCell)?.clearInput()
    }

    override func clearViewModel() {
        super.clearViewModel()
        searchDelegate = nil
    }
}
