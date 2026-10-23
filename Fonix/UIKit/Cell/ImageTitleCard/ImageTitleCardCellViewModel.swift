//
//  ImageTitleCardCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 24.10.2026.
//

import Foundation
import UIKit

protocol ImageTitleCardCellViewModelDelegate: AnyObject {
    func imageTitleCardTapped(_ viewModel: ImageTitleCardCellViewModel)
}

/// Solda görsel, ortada başlık + alt başlık, sağda isteğe bağlı ok. Yakında / profil başlığı gibi satırlar için.
final class ImageTitleCardCellViewModel: BaseCellViewModel {
    weak var actionDelegate: ImageTitleCardCellViewModelDelegate?

    let title: TextAttributes
    let subtitle: TextAttributes
    var image: ImageAttribute
    private(set) var arrowIcon = ImageAttribute()

    init(title: String, subtitle: String, imageName: String = "CryptoLogo", showsArrow: Bool = false) {
        self.title = TextAttributes(text: title, style: .bodyLarge, weight: .bold, color: .gray0)
        self.subtitle = TextAttributes(text: subtitle, style: .bodySmall, weight: .regular, color: .gray30)
        image = ImageAttribute(named: imageName)
        image.cornerRadius = 20
        image.contentMode = .scaleAspectFill
        super.init()
        if showsArrow { addArrow() }
        contentInset = UIEdgeInsets(top: 0, left: AppConstants.Margin2x,
                                    bottom: AppConstants.Marginx, right: AppConstants.Margin2x)
    }

    func addArrow() {
        arrowIcon = ImageAttribute(named: "CaretRight", tintColor: .gray30)
    }

    override func clearViewModel() {
        super.clearViewModel()
        actionDelegate = nil
    }
}
