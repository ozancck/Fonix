//
//  HomeViewModel.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation

@MainActor
final class HomeViewModel: BaseViewModel {
    enum State: Equatable {
        case idle,
             loading,
             loaded, failed(String)
    }

    private(set) var state: State = .idle
    private(set) var home: HomeData?
    private(set) var topEarners: [AssetSummary] = []
    private(set) var favorites: [FavoriteAsset] = []

    /// Durum değişince ekran kendini yeniden kurar.
    var onChange: (() -> Void)?

    private let service: FundServicing
    private weak var navigator: HomeNavigating?
    private let formatter: AmountFormatter

    init(service: FundServicing, navigator: HomeNavigating?, formatter: AmountFormatter = AmountFormatter()) {
        self.service = service
        self.navigator = navigator
        self.formatter = formatter
    }

    // MARK: Yükleme

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

    private func message(for error: APIError) -> String {
        switch error {
        case .server(let message), .httpStatus(_, .some(let message)): return message
        case .transport: return "error_network".localized
        default: return "error_generic".localized
        }
    }

    // MARK: Hücreler

    func makeCellViewModels() -> [BaseCellViewModel] {
        guard state == .loaded else { return [] }
        return portfolioSection() + topEarnersSection() + favoritesSection()
    }

    private func portfolioSection() -> [BaseCellViewModel] {
        let header = SectionLabelCellViewModel(title: "home_portfolio_title".localized)
        guard let home, !home.userAssets.isEmpty else {
            let banner = BannerInfoCellViewModel(title: "home_portfolio_empty_title".localized,
                                                 detail: "home_portfolio_empty_detail".localized,
                                                 actionTitle: "home_portfolio_create".localized)
            banner.actionDelegate = self
            return [header, banner]
        }
        var rows: [BaseCellViewModel] = home.userAssets.map { asset in
            IconInfoCardCellViewModel(assetCode: "",
                                      title: "asset_type_\(asset.assetType)".localized,
                                      subtitle: "\(asset.items.count) " + "asset_item_count".localized,
                                      value: formatter.moneyString(asset.totalAmount),
                                      ratio: formatter.percentString(asset.totalPercentage),
                                      isGain: true)
        }
        let create = ButtonCellViewModel(title: "home_portfolio_create".localized,
                                         iconName: "CaretRight")
        create.actionDelegate = self
        rows.append(create)
        return [header,
                ContainerCellViewModel(viewModels: rows)]
    }

    private func topEarnersSection() -> [BaseCellViewModel] {
        let header = SectionLabelCellViewModel(title: "home_top_earners_title".localized,
                                               actionTitle: "see_all".localized)
        header.actionDelegate = self
        guard !topEarners.isEmpty else {
            return [header, emptyBanner(title: "home_top_earners_empty".localized)]
        }
        return [header,
                ContainerCellViewModel(viewModels: topEarners.map(assetRow))]
        
        
    }

    private func favoritesSection() -> [BaseCellViewModel] {
        let header = SectionLabelCellViewModel(title: "home_favorites_title".localized)
        guard !favorites.isEmpty else {
            return [header, emptyBanner(title: "home_favorites_empty".localized)]
        }
        return [header,
                ContainerCellViewModel(viewModels: favorites.map { assetRow($0.summary) })]
    }

    private func assetRow(_ asset: AssetSummary) -> IconInfoCardCellViewModel {
        let row = IconInfoCardCellViewModel(assetCode: asset.assetCode,
                                            title: asset.assetCode,
                                            subtitle: asset.assetSubTitle,
                                            value: formatter.fundPriceString(asset.price ?? 0),
                                            ratio: formatter.percentString(asset.ratio ?? 0),
                                            isGain: asset.isGain)
        row.actionDelegate = self
        return row
    }

    private func emptyBanner(title: String) -> BannerInfoCellViewModel {
        let banner = BannerInfoCellViewModel(title: title,
                                             detail: "home_empty_detail".localized,
                                             actionTitle: "home_explore_all".localized)
        banner.actionDelegate = self
        return banner
    }
}

// MARK: - Hücre dokunmaları

extension HomeViewModel: IconInfoCardCellViewModelDelegate, SectionLabelCellViewModelDelegate,
                         BannerInfoCellViewModelDelegate, ButtonCellViewModelDelegate {
    func iconInfoCardTapped(_ viewModel: IconInfoCardCellViewModel) {
        guard !viewModel.assetCode.isEmpty else { return }
        navigator?.showAssetDetail(assetCode: viewModel.assetCode)
    }

    func sectionLabelActionTapped(_ viewModel: SectionLabelCellViewModel) {
        navigator?.showExplore()
    }

    func bannerInfoTapped(_ viewModel: BannerInfoCellViewModel) {
        home?.userAssets.isEmpty == true ? navigator?.showCreatePortfolio() : navigator?.showExplore()
    }

    func buttonTapped(_ viewModel: ButtonCellViewModel) {
        navigator?.showCreatePortfolio()
    }
}
