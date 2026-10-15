//
//  ContainerCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

final class ContainerCellViewModel: BaseCellViewModel {
    var viewModels: [BaseCellViewModel]
    var containerBackgroundColor: UIColor = AppColor.gray80.uiColor
    var cornerRadius: CGFloat = 16

    init(viewModels: [BaseCellViewModel] = []) {
        self.viewModels = viewModels
        super.init()
        contentInset = UIEdgeInsets(top: 0, left: AppConstants.Margin2x,
                                    bottom: AppConstants.Margin2x, right: AppConstants.Margin2x)
    }

    override func makeCell() -> BaseTableViewCell? { ContainerTableViewCell() }

    override func validate() -> String? {
        for viewModel in viewModels where viewModel.visible {
            if let message = viewModel.validate() { return message }
        }
        return nil
    }

    override func fixedHeight() -> CGFloat {
        viewModels.reduce((contentInset?.top ?? 0) + (contentInset?.bottom ?? 0)) { $0 + $1.fixedHeight() }
    }

    override func clearViewModel() {
        viewModels.forEach { $0.clearViewModel() }
        super.clearViewModel()
    }
}

final class ContainerTableViewCell: BaseTableViewCell {
    private let backgroundCard = UIView()
    private let stack = UIStackView()
    private var edgeConstraints: [NSLayoutConstraint] = []

    init() {
        super.init(style: .default, reuseIdentifier: nil)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(backgroundCard)
        backgroundCard.addSubview(stack)
        backgroundCard.translatesAutoresizingMaskIntoConstraints = false
        backgroundCard.clipsToBounds = true
        stack.axis = .vertical
        stack.pinToEdges(of: backgroundCard)
        edgeConstraints = [
            backgroundCard.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        edgeConstraints[1].priority = .defaultHigh
        NSLayoutConstraint.activate(edgeConstraints)
    }

    required init?(coder: NSCoder) { nil }

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? ContainerCellViewModel else { return }
        backgroundCard.backgroundColor = viewModel.containerBackgroundColor
        backgroundCard.layer.cornerRadius = viewModel.cornerRadius
        let inset = viewModel.contentInset ?? .zero
        edgeConstraints[0].constant = inset.top
        edgeConstraints[1].constant = -inset.bottom
        edgeConstraints[2].constant = inset.left
        edgeConstraints[3].constant = -inset.right

        stack.removeAllArrangedSubviews()
        for child in viewModel.viewModels where child.visible {
            guard let cell = child.makeCell() else { continue }
            child.reloadDelegate = viewModel.reloadDelegate
            child.cell = cell
            cell.set(viewModel: child)
            stack.addArrangedSubview(cell.contentView)
        }
    }
}
