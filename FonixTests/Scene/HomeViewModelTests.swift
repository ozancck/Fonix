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

    private func home(assets: [UserAsset] = []) -> HomeData {
        HomeData(totalAmount: 100, userPortfolios: [], userAssets: assets)
    }

    private func earner(_ code: String, ratio: String) -> AssetSummary {
        AssetSummary(assetId: "1", assetCode: code, assetType: "fund", assetTitle: code,
                     assetLongTitle: "", assetSubTitle: "Kurucu", assetPrice: "10.5",
                     assetRatio: ratio, assetImage: nil)
    }

    func test_load_success_storesDataAndState() async {
        service.homeDataResult = .success(home())
        service.topEarnersResult = .success([earner("AFT", ratio: "2.1")])

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.topEarners.map(\.assetCode), ["AFT"])
        XCTAssertFalse(viewModel.hasPortfolio)
    }

    func test_load_failure_setsMessageFromServer() async {
        service.homeDataResult = .failure(APIError.server("Sunucu işlemi reddetti"))

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .failed("Sunucu işlemi reddetti"))
    }

    func test_load_notifiesOnChange_twice() async {
        service.homeDataResult = .success(home())
        var calls = 0
        viewModel.onChange = { calls += 1 }

        await viewModel.load()

        XCTAssertEqual(calls, 2)
    }

    func test_showAssetDetail_ignoresEmptyCode() {
        viewModel.showAssetDetail(assetCode: "")
        XCTAssertNil(navigator.shownAsset)

        viewModel.showAssetDetail(assetCode: "MAC")
        XCTAssertEqual(navigator.shownAsset, "MAC")
    }

    func test_bannerTapped_goesToCreatePortfolio_whenEmpty_elseExplore() async {
        service.homeDataResult = .success(home())
        await viewModel.load()
        viewModel.bannerTapped()
        XCTAssertEqual(navigator.createPortfolioCount, 1)

        let asset = UserAsset(assetType: "fund", totalAmount: 1, totalPercentage: 100, assetTypeIcon: nil, items: [])
        service.homeDataResult = .success(home(assets: [asset]))
        await viewModel.load()
        viewModel.bannerTapped()
        XCTAssertEqual(navigator.exploreCount, 1)
    }
}
