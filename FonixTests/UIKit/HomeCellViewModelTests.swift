//
//  HomeCellViewModelTests.swift
//  FonixTests
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import XCTest
@testable import Fonix

final class HomeCellViewModelTests: XCTestCase {
    func test_scrollSegment_selectMarksOnlyOneItem() {
        let items = ["fund", "bes", "bist"].map { ScrollSegmentItem(identifier: $0, title: $0, iconName: "Briefcase") }
        let viewModel = ScrollSegmentCellViewModel(items: items, selectedIndex: 1)

        XCTAssertEqual(viewModel.selectedItem?.identifier, "bes")
        viewModel.select(index: 2)
        XCTAssertEqual(viewModel.items.filter { $0.selected }.map { $0.identifier }, ["bist"])
        viewModel.select(index: 9)
        XCTAssertEqual(viewModel.selectedIndex, 2)
    }

    func test_scrollSelection_singleVersusMulti() {
        let single = ScrollSelectionCellViewModel(items: [
            ScrollSelectionItem(identifier: "a", title: "A"),
            ScrollSelectionItem(identifier: "b", title: "B")
        ])
        single.toggle(index: 0)
        single.toggle(index: 1)
        XCTAssertEqual(single.selectedItems.map { $0.identifier }, ["b"])

        let multi = ScrollSelectionCellViewModel(items: [
            ScrollSelectionItem(identifier: "a", title: "A"),
            ScrollSelectionItem(identifier: "b", title: "B")
        ], multiSelection: true)
        multi.toggle(index: 0)
        multi.toggle(index: 1)
        XCTAssertEqual(multi.selectedItems.count, 2)
        multi.toggle(index: 0)
        XCTAssertEqual(multi.selectedItems.map { $0.identifier }, ["b"])
    }

    func test_scrollSelection_requiredWithoutChoice_fails() {
        let viewModel = ScrollSelectionCellViewModel(items: [ScrollSelectionItem(identifier: "a", title: "A")])
        viewModel.isRequired = true
        XCTAssertNotNil(viewModel.validate())
        viewModel.toggle(index: 0)
        XCTAssertNil(viewModel.validate())
    }

    func test_expandHeader_toggleFlipsArrow() {
        let viewModel = ExpandHeaderCellViewModel(title: "Fon", subtitle: "3", value: "₺1", iconName: "Briefcase")
        XCTAssertEqual(viewModel.arrowIcon.source, .asset("CaretDown"))
        viewModel.toggle()
        XCTAssertTrue(viewModel.isExpanded)
        XCTAssertEqual(viewModel.arrowIcon.source, .asset("CaretUp"))
    }

    func test_gainFlag_drivesColorsAndIcons() {
        let gain = ExpandItemCellViewModel(title: "", subtitle: "", value: "", ratio: "", isGain: true)
        let loss = CategoryItemCellViewModel(title: "", value: "", iconName: "Coins", isGain: false)
        let trend = TrendInfoCardItem(title: "", ratio: "", value: "", isGain: false)
        let detail = TrendDetailItem(title: "", ratio: "", value: "", isGain: true)

        XCTAssertEqual(gain.ratio.color, AppColor.success50.uiColor)
        XCTAssertEqual(loss.value.color, AppColor.destructive50.uiColor)
        XCTAssertEqual(trend.trendIcon.source, .asset("TrendDown"))
        XCTAssertEqual(detail.detailImage.source, .asset("LineChartMini"))
    }

    func test_articleCard_hidesMarketInfoWhenEmpty() {
        let without = ArticleCardCellViewModel(date: "", category: "", title: "", detail: "", imageName: "Frame")
        let with = ArticleCardCellViewModel(date: "", category: "", title: "", detail: "", imageName: "Frame", marketInfo: "SHIB -8%")
        XCTAssertFalse(without.showMarketInfo)
        XCTAssertTrue(with.showMarketInfo)
    }

    func test_homeCells_loadFromXibAndBind() {
        let viewModels: [BaseCellViewModel] = [
            BannerActionCellViewModel(title: "t", detail: "d", actionTitle: "a"),
            CategoryItemCellViewModel(title: "t", value: "v", iconName: "Coins"),
            ArticleCardCellViewModel(date: "", category: "", title: "", detail: "", imageName: "Frame"),
            RecommendedTopicsCellViewModel(items: [RecommendedTopicItem(title: "x")]),
            InfoCardCarouselCellViewModel(items: [InfoCardCarouselItem(title: "", value: "", ratio: "", isGain: true)]),
            ExpandHeaderCellViewModel(title: "", subtitle: "", value: "", iconName: "Briefcase"),
            ExpandItemCellViewModel(title: "", subtitle: "", value: "", ratio: "", isGain: true),
            TrendInfoCarouselCellViewModel(items: [TrendInfoCardItem(title: "", ratio: "", value: "", isGain: true)]),
            TrendDetailCarouselCellViewModel(items: [TrendDetailItem(title: "", ratio: "", value: "", isGain: true)]),
            ScrollSegmentCellViewModel(items: [ScrollSegmentItem(identifier: "a", title: "A")]),
            ScrollSelectionCellViewModel(items: [ScrollSelectionItem(identifier: "a", title: "A")])
        ]
        for viewModel in viewModels {
            let cell = viewModel.makeCell()
            XCTAssertNotNil(cell, "\(viewModel.cellIdentifier()) yüklenemedi")
            cell?.set(viewModel: viewModel)
        }
    }
}
