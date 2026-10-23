//
//  ExploreViewModelTests.swift
//  FonixTests
//
//  Created by Ozan on 24.10.2026.
//

import XCTest
@testable import Fonix

private final class NavigatorSpy: ExploreNavigating {
    var shownAsset: String?
    var shownCategory: String?
    var shownAllType: TopFundType?
    func showAssetDetail(assetCode: String) { shownAsset = assetCode }
    func showCategory(code: String) { shownCategory = code }
    func showAllFunds(type: TopFundType) { shownAllType = type }
}

@MainActor
final class ExploreViewModelTests: XCTestCase {
    private var service: FakeFundService!
    private var navigator: NavigatorSpy!
    private var viewModel: ExploreViewModel!

    override func setUp() {
        super.setUp()
        service = FakeFundService()
        navigator = NavigatorSpy()
        viewModel = ExploreViewModel(service: service, navigator: navigator)
    }

    private func fund(_ code: String, ratio: String = "1.0") -> AssetSummary {
        AssetSummary(assetId: "1", assetCode: code, assetType: "fund", assetTitle: code,
                     assetLongTitle: "", assetSubTitle: "Kurucu", assetPrice: "10.5",
                     assetRatio: ratio, assetImage: nil)
    }

    private func category(_ code: String) -> FundCategory {
        FundCategory(categoryId: code, categoryTitle: code, categoryCode: code, categoryIcon: nil)
    }

    func test_load_success_storesCategoriesAndTopFunds() async {
        service.fundCategoriesResult = .success([category("equity")])
        service.topFundsResult = .success([fund("MAC", ratio: "3.05")])

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.categories.map(\.categoryCode), ["equity"])
        XCTAssertEqual(viewModel.topFunds.map(\.assetCode), ["MAC"])
        XCTAssertEqual(service.requestedTopFundTypes, [.earned])
    }

    func test_load_failure_setsMessageFromServer() async {
        service.fundCategoriesResult = .failure(APIError.server("Sunucu işlemi reddetti"))

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .failed("Sunucu işlemi reddetti"))
    }

    func test_selectTopFundType_requestsNewTypeOnly() async {
        await viewModel.load()

        await viewModel.selectTopFundType(.leader)
        await viewModel.selectTopFundType(.leader)

        XCTAssertEqual(viewModel.selectedTopFundType, .leader)
        XCTAssertEqual(service.requestedTopFundTypes, [.earned, .leader])
    }

    func test_selectTopFundType_failure_keepsLoadedStateAndQueuesError() async {
        await viewModel.load()
        service.topFundsResult = .failure(APIError.server("Liste alınamadı"))

        await viewModel.selectTopFundType(.investor)

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.takeError(), "Liste alınamadı")
        XCTAssertNil(viewModel.takeError())
    }

    func test_search_shortQuery_clearsWithoutRequest() async {
        service.searchFundsResult = .success([fund("AFT")])

        await viewModel.search(query: "a")

        XCTAssertFalse(viewModel.isSearching)
        XCTAssertTrue(viewModel.searchResults.isEmpty)
        XCTAssertTrue(service.searchedQueries.isEmpty)
    }

    func test_search_trimsAndStoresResults() async {
        service.searchFundsResult = .success([fund("AFT")])

        await viewModel.search(query: "  af ")

        XCTAssertTrue(viewModel.isSearching)
        XCTAssertEqual(service.searchedQueries, ["af"])
        XCTAssertEqual(viewModel.searchResults.map(\.assetCode), ["AFT"])
    }

    func test_selectSegment_changesOnlyWhenDifferent() {
        var calls = 0
        viewModel.onChange = { calls += 1 }

        viewModel.selectSegment(.fund)
        viewModel.selectSegment(.pension)

        XCTAssertEqual(viewModel.selectedSegment, .pension)
        XCTAssertEqual(calls, 1)
    }

    func test_selectCategory_togglesAndNavigates() {
        viewModel.selectCategory(code: "equity")
        XCTAssertEqual(viewModel.selectedCategoryCode, "equity")
        XCTAssertEqual(navigator.shownCategory, "equity")

        viewModel.selectCategory(code: "equity")
        XCTAssertNil(viewModel.selectedCategoryCode)
    }

    func test_navigation_helpers() {
        viewModel.showAssetDetail(assetCode: "")
        XCTAssertNil(navigator.shownAsset)

        viewModel.showAssetDetail(assetCode: "MAC")
        XCTAssertEqual(navigator.shownAsset, "MAC")

        viewModel.showAllFunds()
        XCTAssertEqual(navigator.shownAllType, .earned)
    }
}
