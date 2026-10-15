//
//  CellViewModelTests.swift
//  FonixTests
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import XCTest
@testable import Fonix

final class CellViewModelTests: XCTestCase {
    func test_iconInfoCard_gainUsesSuccessColor_lossUsesDestructive() {
        let gain = IconInfoCardCellViewModel(assetCode: "AFT", title: "AFT", subtitle: "", value: "", ratio: "2.1", isGain: true)
        let loss = IconInfoCardCellViewModel(assetCode: "TTE", title: "TTE", subtitle: "", value: "", ratio: "-0.8", isGain: false)

        XCTAssertEqual(gain.ratio.color, AppColor.success50.uiColor)
        XCTAssertEqual(loss.ratio.color, AppColor.destructive50.uiColor)
    }

    func test_sectionLabel_withoutActionTitle_hasNoButton() {
        XCTAssertNil(SectionLabelCellViewModel(title: "Favoriler").actionButton)
        XCTAssertNotNil(SectionLabelCellViewModel(title: "Favoriler", actionTitle: "Tümü").actionButton)
    }

    func test_container_mountsVisibleChildrenOnly() {
        let hidden = EmptyCellViewModel(height: 5)
        hidden.visible = false
        let container = ContainerCellViewModel(viewModels: [EmptyCellViewModel(height: 10), hidden])
        let cell = container.makeCell()!

        cell.set(viewModel: container)

        let stack = cell.contentView.subviews.first?.subviews.first as? UIStackView
        XCTAssertEqual(stack?.arrangedSubviews.count, 1)
    }

    func test_xibCells_loadByConvention() {
        XCTAssertNotNil(SectionLabelCellViewModel(title: "x").makeCell())
        XCTAssertNotNil(IconInfoCardCellViewModel(assetCode: "x", title: "", subtitle: "", value: "", ratio: "", isGain: true).makeCell())
        XCTAssertNotNil(BannerInfoCellViewModel(title: "", detail: "", actionTitle: "").makeCell())
    }
}
