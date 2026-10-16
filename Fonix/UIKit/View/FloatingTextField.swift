//
//  FloatingTextField.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class FloatingTextField: UIView {
    let textField = UITextField()
    private let titleLabel = UILabel()
    private let rightImageView = UIImageView()
    private let textStack = UIStackView()
    private var title = TextAttributes()

    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        build()
    }

    var text: String {
        get { textField.text ?? "" }
        set {
            textField.text = newValue
            updateTitleVisibility(animated: false)
        }
    }

    func configure(title: TextAttributes,
                   placeholder: TextAttributes,
                   text: TextAttributes,
                   backgroundColor: UIColor) {
        self.title = title
        title.apply(to: titleLabel)
        textField.font = text.font
        textField.textColor = text.color
        textField.text = text.text
        textField.attributedPlaceholder = placeholder.attributedString
        self.backgroundColor = backgroundColor
        updateTitleVisibility(animated: false)
    }

    func setRightIcon(_ icon: ImageAttribute) {
        rightImageView.isHidden = icon.isEmpty
        icon.apply(to: rightImageView)
    }

    func updateTitleVisibility(animated: Bool = true) {
        let hidden = title.text.isEmpty || (text.isEmpty && !textField.isFirstResponder)
        guard titleLabel.isHidden != hidden else { return }
        let change = {
            self.titleLabel.isHidden = hidden
            self.textStack.layoutIfNeeded()
        }
        if animated {
            UIView.animate(withDuration: 0.2, animations: change)
        } else {
            change()
        }
    }

    private func build() {
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(textField)
        titleLabel.isHidden = true

        rightImageView.isHidden = true
        rightImageView.contentMode = .scaleAspectFit

        let row = UIStackView(arrangedSubviews: [textStack, rightImageView])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = AppConstants.Marginx
        addSubview(row)
        row.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppConstants.Margin2x),
            row.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppConstants.Margin2x),
            row.centerYAnchor.constraint(equalTo: centerYAnchor),
            row.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: AppConstants.Marginx),
            rightImageView.widthAnchor.constraint(equalToConstant: 20),
            rightImageView.heightAnchor.constraint(equalToConstant: 20)
        ])

        textField.borderStyle = .none
        textField.autocorrectionType = .no
        for event in [UIControl.Event.editingDidBegin, .editingDidEnd, .editingChanged] {
            textField.addTarget(self, action: #selector(editingStateChanged), for: event)
        }
    }

    @objc private func editingStateChanged() {
        updateTitleVisibility()
    }
}
