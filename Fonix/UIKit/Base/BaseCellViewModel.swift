//
//  BaseCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

protocol CellReloading: AnyObject {
    func reloadCell(_ viewModel: BaseCellViewModel)
    func reloadAllCells()
}

struct CellSeparator {
    var color: UIColor = AppColor.gray70.uiColor
    var inset = UIEdgeInsets(top: 0,
                             left: AppConstants.Margin2x,
                             bottom: 0,
                             right: AppConstants.Margin2x)
}

class BaseCellViewModel: NSObject {
    weak var cell: BaseTableViewCell?
    weak var reloadDelegate: CellReloading?

    var identifier = UUID().uuidString
    var visible = true
    var disabled = false
    var canDelete = false
    var backgroundColor: UIColor = .clear
    var separator: CellSeparator?
    /// nil ise xib'deki sabitler kullanılır.
    var contentInset: UIEdgeInsets?

    /// Varsayılan: "FooCellViewModel" -> "FooTableViewCell". Xib adı bununla aynı olmalı.
    func cellIdentifier() -> String {
        String(describing: type(of: self))
            .replacingOccurrences(of: "CellViewModel", with: "TableViewCell")
    }

    /// Hücreyi üretir. Xib'siz hücreler override eder.
    func makeCell() -> BaseTableViewCell? {
        let nib = UINib(nibName: cellIdentifier(), bundle: .main)
        return nib.instantiate(withOwner: nil).first as? BaseTableViewCell
    }

    /// Hata mesajı döner, geçerliyse nil.
    func validate() -> String? { nil }

    /// Header/footer alanında kapladığı yükseklik.
    func fixedHeight() -> CGFloat { AppConstants.Marginx }

    func reload() { reloadDelegate?.reloadCell(self) }
    func reloadContent() { cell?.set(viewModel: self) }

    func cellWillAppear() { cell?.cellWillAppear() }
    func cellWillDisappear() { cell?.cellWillDisappear() }

    func clearViewModel() {
        cell?.clearView()
        cell = nil
        reloadDelegate = nil
    }

    deinit { AppLog.deinitialize(self) }
}
