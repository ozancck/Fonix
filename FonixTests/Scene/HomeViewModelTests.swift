//
//  HomeViewModelTests.swift
//  FonixTests
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import XCTest
@testable import Fonix

private final class NavigatorSpy: HomeNavigating {
    var shownAsset: String?
    var exploreCount = 0
    var createPortfolioCount = 0
    func showAssetDetail(assetCode: String) { shownAsset = assetCode }
    func showExplore() { exploreCount += 1 }
    func showCreatePortfolio() { createPortfolioCount += 1 }
}

@MainActor
final class HomeViewModelTests: XCTestCase {
    private var service: FakeFundService!
    private var navigator: NavigatorSpy!
    private var viewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        service = FakeFundService()
        navigator = NavigatorSpy()
        viewModel = HomeViewModel(service: service, navigator: navigator)
    }

    private func loadedHome(assets: [UserAsset] = []) -> HomeData {
        HomeData(totalAmount: 100, userPortfolios: [], userAssets: assets)
    }

    private func earner(_ code: String, ratio: String) -> AssetSummary {
        AssetSummary(assetId: "1", assetCode: code, assetType: "fund", assetTitle: code,
                     assetLongTitle: "", assetSubTitle: "Kurucu", assetPrice: "10.5", assetRatio: ratio)
    }

    func test_load_success_buildsThreeSections() async {
        service.homeDataResult = .success(loadedHome())
        service.topEarnersResult = .success([earner("AFT", ratio: "2.1")])

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .loaded)
        let cells = viewModel.makeCellViewModels()
        XCTAssertEqual(cells.filter { $0 is SectionLabelCellViewModel }.count, 3)
        XCTAssertEqual(cells.filter { $0 is ContainerCellViewModel }.count, 1)   // kazandıranlar
        XCTAssertEqual(cells.filter { $0 is BannerInfoCellViewModel }.count, 2)  // portföy ve favori boş
    }

    func test_load_failure_setsMessageFromServer() async {
        service.homeDataResult = .failure(APIError.server("Sunucu işlemi reddetti"))

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .failed("Sunucu işlemi reddetti"))
        XCTAssertTrue(viewModel.makeCellViewModels().isEmpty)
    }

    func test_load_notifiesOnChange_twice() async {
        service.homeDataResult = .success(loadedHome())
        var calls = 0
        viewModel.onChange = { calls += 1 }

        await viewModel.load()

        XCTAssertEqual(calls, 2)   // loading ve loaded
    }

    func test_tappingEarner_navigatesToAssetDetail() async {
        service.homeDataResult = .success(loadedHome())
        service.topEarnersResult = .success([earner("MAC", ratio: "3.05")])
        await viewModel.load()
        let container = viewModel.makeCellViewModels().compactMap { $0 as? ContainerCellViewModel }.first
        let row = container?.viewModels.first as? IconInfoCardCellViewModel

        viewModel.iconInfoCardTapped(row!)

        XCTAssertEqual(navigator.shownAsset, "MAC")
    }

    func test_emptyPortfolioBanner_navigatesToCreatePortfolio() async {
        service.homeDataResult = .success(loadedHome())
        await viewModel.load()
        let banner = viewModel.makeCellViewModels().compactMap { $0 as? BannerInfoCellViewModel }.first

        viewModel.bannerInfoTapped(banner!)

        XCTAssertEqual(navigator.createPortfolioCount, 1)
    }
}
