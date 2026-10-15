//
//  ButtonTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

final class ButtonTableViewCell: BaseTableViewCell {
    private let button = UIButton(type: .system)
    private var heightConstraint: NSLayoutConstraint!
    private var edgeConstraints: [NSLayoutConstraint] = []
    private var buttonViewModel: ButtonCellViewModel?

    init() {
        super.init(style: .default, reuseIdentifier: nil)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = button.heightAnchor.constraint(equalToConstant: 40)
        edgeConstraints = [
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        edgeConstraints[1].priority = .defaultHigh
        NSLayoutConstraint.activate(edgeConstraints + [heightConstraint])
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) { nil }

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? ButtonCellViewModel else { return }
        buttonViewModel = viewModel
        viewModel.button.apply(to: button)
        heightConstraint.constant = viewModel.height
        let inset = viewModel.contentInset ?? .zero
        edgeConstraints[0].constant = inset.top
        edgeConstraints[1].constant = -inset.bottom
        edgeConstraints[2].constant = inset.left
        edgeConstraints[3].constant = -inset.right
    }

    override func clearView() {
        super.clearView()
        buttonViewModel = nil
    }

    @objc private func tapped() {
        guard let buttonViewModel else { return }
        button.bounce(scale: buttonViewModel.button.bounceScale)
        buttonViewModel.actionDelegate?.buttonTapped(buttonViewModel)
    }
}
