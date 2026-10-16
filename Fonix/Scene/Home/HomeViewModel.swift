import Foundation

@MainActor
final class HomeViewModel: BaseViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    private(set) var state: State = .idle
    private(set) var home: HomeData?
    private(set) var topEarners: [AssetSummary] = []
    private(set) var favorites: [FavoriteAsset] = []

    var onChange: (() -> Void)?

    let formatter: AmountFormatter
    private let service: FundServicing
    private weak var navigator: HomeNavigating?

    init(service: FundServicing,
         navigator: HomeNavigating?,
         formatter: AmountFormatter = AmountFormatter()) {
        self.service = service
        self.navigator = navigator
        self.formatter = formatter
    }

    var hasPortfolio: Bool { !(home?.userAssets.isEmpty ?? true) }

    func load() async {
        state = .loading
        onChange?()
        do {
            async let home = service.homeData()
            async let earners = service.topEarners()
            async let favorites = service.favoriteAssets()
            self.home = try await home
            self.topEarners = try await earners
            self.favorites = try await favorites
            state = .loaded
        } catch let error as APIError {
            state = .failed(message(for: error))
        } catch {
            state = .failed(error.localizedDescription)
        }
        onChange?()
    }

    func showAssetDetail(assetCode: String) {
        guard !assetCode.isEmpty else { return }
        navigator?.showAssetDetail(assetCode: assetCode)
    }

    func showExplore() {
        navigator?.showExplore()
    }

    func showCreatePortfolio() {
        navigator?.showCreatePortfolio()
    }

    func bannerTapped() {
        if hasPortfolio {
            navigator?.showExplore()
        } else {
            navigator?.showCreatePortfolio()
        }
    }

    private func message(for error: APIError) -> String {
        switch error {
        case .server(let message), .httpStatus(_, .some(let message)): return message
        case .transport: return "error_network".localized
        default: return "error_generic".localized
        }
    }
}
