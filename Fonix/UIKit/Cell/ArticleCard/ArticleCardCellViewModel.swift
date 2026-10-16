//
//  ArticleCardCellViewModel.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

protocol ArticleCardCellViewModelDelegate: AnyObject {
    func articleCardTapped(_ viewModel: ArticleCardCellViewModel)
    func articleCardMoreTapped(_ viewModel: ArticleCardCellViewModel)
}

final class ArticleCardCellViewModel: BaseCellViewModel {
    weak var actionDelegate: ArticleCardCellViewModelDelegate?

    let date: TextAttributes
    let category: TextAttributes
    let title: TextAttributes
    let detail: TextAttributes
    let viewsCount: TextAttributes
    let likesCount: TextAttributes
    let marketInfo: TextAttributes

    var image: ImageAttribute
    var viewsIcon = ImageAttribute(named: "Eye", tintColor: .gray30)
    var likesIcon = ImageAttribute(named: "Heart", tintColor: .destructive60)
    var headerDot = ImageAttribute(named: "_Dot")
    var footerDot = ImageAttribute(named: "_Dot")
    var moreIcon = ImageAttribute(named: "DotsThreeOutline")
    var marketInfoIcon = ImageAttribute(named: "CaretRatioDown")
    var showMarketInfo = true
    var cornerRadius: CGFloat = 24

    init(date: String,
         category: String,
         title: String,
         detail: String,
         imageName: String,
         marketInfo: String = "",
         viewsCount: String = "",
         likesCount: String = "") {
        self.date = TextAttributes(text: date, style: .bodySmall, weight: .regular, color: .gray30)
        self.category = TextAttributes(text: category, style: .bodySmall, weight: .regular, color: .gray30)
        self.title = TextAttributes(text: title, style: .bodyXLarge, weight: .bold, color: .gray0)
        self.detail = TextAttributes(text: detail, style: .bodySmall, weight: .regular, color: .gray30)
        self.viewsCount = TextAttributes(text: viewsCount, style: .bodySmall, weight: .semibold, color: .gray30)
        self.likesCount = TextAttributes(text: likesCount, style: .bodySmall, weight: .semibold, color: .gray30)
        self.marketInfo = TextAttributes(text: marketInfo, style: .bodySmall, weight: .semibold, color: .gray30)
        image = ImageAttribute(named: imageName)
        image.contentMode = .scaleAspectFill
        image.cornerRadius = 12
        showMarketInfo = !marketInfo.isEmpty
        super.init()
    }

    override func clearViewModel() {
        super.clearViewModel()
        actionDelegate = nil
    }
}
