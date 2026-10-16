//
//  RecommendedTopicsCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

protocol RecommendedTopicsCellViewModelDelegate: AnyObject {
    func recommendedTopicTapped(_ viewModel: RecommendedTopicsCellViewModel, at index: Int)
}

final class RecommendedTopicItem {
    let title: TextAttributes
    var image: ImageAttribute

    init(title: String, imageName: String = "AvatarIllustration") {
        self.title = TextAttributes(text: title, style: .bodyXSmall, weight: .regular, color: .gray10)
        self.title.alignment = .center
        image = ImageAttribute(named: imageName)
        image.contentMode = .scaleAspectFill
        image.cornerRadius = 20
    }
}

final class RecommendedTopicsCellViewModel: BaseCellViewModel {
    weak var actionDelegate: RecommendedTopicsCellViewModelDelegate?

    var items: [RecommendedTopicItem]
    var lineSpacing: CGFloat = 4
    var interitemSpacing: CGFloat = 0
    var selectedIndex = 0

    init(items: [RecommendedTopicItem]) {
        self.items = items
        super.init()
        contentInset = .zero
    }

    override func clearViewModel() {
        super.clearViewModel()
        actionDelegate = nil
    }
}
