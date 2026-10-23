//
//  ExploreCellViewModelTests.swift
//  FonixTests
//
//  Created by Ozan on 24.10.2026.
//

import Foundation
import XCTest
@testable import Fonix

final class ExploreCellViewModelTests: XCTestCase {
    private func tabItems() -> [TabSegmentItem] {
        ["fund", "pension", "auto"].map { TabSegmentItem(identifier: $0, title: $0) }
    }

    func test_tabSegment_selectMarksOnlyOneItem() {
        let viewModel = TabSegmentCellViewModel(items: tabItems(), selectedIndex: 1)

        XCTAssertEqual(viewModel.selectedItem?.identifier, "pension")
        viewModel.select(index: 2)
        XCTAssertEqual(viewModel.items.filter { $0.selected }.map { $0.identifier }, ["auto"])
        viewModel.select(index: 9)
        XCTAssertEqual(viewModel.selectedIndex, 2)
    }

    func test_tabSegment_selectByIdentifier() {
        let viewModel = TabSegmentCellViewModel(items: tabItems())

        viewModel.select(identifier: "pension")
        XCTAssertEqual(viewModel.selectedIndex, 1)
        viewModel.select(identifier: "yok")
        XCTAssertEqual(viewModel.selectedIndex, 1)
    }

    func test_tabSegmentItem_selectedStateDrivesTitleAndBar() {
        let item = TabSegmentItem(identifier: "fund", title: "Fon")

        XCTAssertEqual(item.title.color, AppColor.gray50.uiColor)
        XCTAssertEqual(item.barColor, .clear)
        item.selected = true
        XCTAssertEqual(item.title.color, AppColor.gray0.uiColor)
        XCTAssertEqual(item.barColor, AppColor.brand60.uiColor)
    }

    func test_imageTitleCard_arrowOnlyWhenRequested() {
        XCTAssertTrue(ImageTitleCardCellViewModel(title: "a", subtitle: "b").arrowIcon.isEmpty)
        let withArrow = ImageTitleCardCellViewModel(title: "a", subtitle: "b", showsArrow: true)
        XCTAssertEqual(withArrow.arrowIcon.source, .asset("CaretRight"))
    }

    func test_imageTitleCard_tapReachesDelegate() {
        final class Spy: ImageTitleCardCellViewModelDelegate {
            var taps = 0
            func imageTitleCardTapped(_ viewModel: ImageTitleCardCellViewModel) { taps += 1 }
        }
        let spy = Spy()
        let viewModel = ImageTitleCardCellViewModel(title: "Fon", subtitle: "Portföy")
        viewModel.actionDelegate = spy
        let cell = viewModel.makeCell()!

        cell.set(viewModel: viewModel)
        let button = cell.contentView.subviews.compactMap { $0 as? UIButton }.first
        button?.sendActions(for: .touchUpInside)

        XCTAssertEqual(spy.taps, 1)
    }

    func test_xibCells_loadByConvention() {
        XCTAssertNotNil(TabSegmentCellViewModel(items: tabItems()).makeCell())
        XCTAssertNotNil(ImageTitleCardCellViewModel(title: "", subtitle: "").makeCell())
    }
}
