import UIKit

final class HomeViewController: BaseFormViewController {
    private let viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func screenIdentifier() -> String { "tab_home" }
    override func supportsPullToRefresh() -> Bool { true }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onChange = { [weak self] in self?.render() }
        Task { await viewModel.load() }
    }

    override func didPullToRefresh() {
        Task { await viewModel.load() }
    }

    override func prepareViewModels() {
        guard viewModel.state == .loaded else { return }
        let formatter = viewModel.formatter

        //////////////////////////// MARK: - Portföyüm

        viewModels.append(SectionLabelCellViewModel(title: "home_portfolio_title".localized))

        if let home = viewModel.home,
           viewModel.hasPortfolio {
            var rows: [BaseCellViewModel] = []
            for asset in home.userAssets {
                let row = IconInfoCardCellViewModel(assetCode: "",
                                                    title: "asset_type_\(asset.assetType)".localized,
                                                    subtitle: "\(asset.items.count) " + "asset_item_count".localized,
                                                    value: formatter.moneyString(asset.totalAmount),
                                                    ratio: formatter.percentString(asset.totalPercentage),
                                                    isGain: true)
                if let url = asset.iconURL {
                    row.image = ImageAttribute(source: .remote(url))
                }
                row.image.cornerRadius = 20
                row.image.contentMode = .scaleAspectFill
                row.separator = CellSeparator()
                rows.append(row)
            }
            let create = ButtonCellViewModel(title: "home_portfolio_create".localized, iconName: "CaretRight")
            create.actionDelegate = self
            rows.append(create)
            viewModels.append(ContainerCellViewModel(viewModels: rows))
        } else {
            let banner = BannerInfoCellViewModel(title: "home_portfolio_empty_title".localized,
                                                 detail: "home_portfolio_empty_detail".localized,
                                                 actionTitle: "home_portfolio_create".localized)
            banner.actionDelegate = self
            viewModels.append(banner)
        }

        //////////////////////////// MARK: - En çok kazandıranlar

        let earnersHeader = SectionLabelCellViewModel(title: "home_top_earners_title".localized,
                                                      actionTitle: "see_all".localized)
        earnersHeader.actionDelegate = self
        viewModels.append(earnersHeader)

        if viewModel.topEarners.isEmpty {
            viewModels.append(emptyBanner(title: "home_top_earners_empty".localized))
        } else {
            viewModels.append(ContainerCellViewModel(viewModels: assetRows(viewModel.topEarners)))
        }

        //////////////////////////// MARK: - Favorilerim

        viewModels.append(SectionLabelCellViewModel(title: "home_favorites_title".localized))

        if viewModel.favorites.isEmpty {
            viewModels.append(emptyBanner(title: "home_favorites_empty".localized))
        } else {
            viewModels.append(ContainerCellViewModel(viewModels: assetRows(viewModel.favorites.map(\.summary))))
        }
    }

    private func assetRows(_ assets: [AssetSummary]) -> [BaseCellViewModel] {
        let formatter = viewModel.formatter
        return assets.enumerated().map { index, asset in
            let row = IconInfoCardCellViewModel(assetCode: asset.assetCode,
                                                title: asset.assetCode,
                                                subtitle: asset.assetSubTitle,
                                                value: formatter.fundPriceString(asset.price ?? 0),
                                                ratio: formatter.percentString(asset.ratio ?? 0),
                                                isGain: asset.isGain)
            if let url = asset.imageURL {
                row.image = ImageAttribute(source: .remote(url))
            }
            if index < assets.count - 1 {
                row.separator = CellSeparator()
            }
            row.image.cornerRadius = 20
            row.image.contentMode = .scaleAspectFill
            row.actionDelegate = self
            return row
        }
    }

    private func emptyBanner(title: String) -> BannerInfoCellViewModel {
        let banner = BannerInfoCellViewModel(title: title,
                                             detail: "home_empty_detail".localized,
                                             actionTitle: "home_explore_all".localized)
        banner.actionDelegate = self
        return banner
    }

    private func render() {
        reloadContent()
        if case .failed(let message) = viewModel.state {
            endRefreshing()
            showError(message)
        } else if viewModel.state == .loaded {
            endRefreshing()
        }
    }
}

extension HomeViewController: IconInfoCardCellViewModelDelegate, SectionLabelCellViewModelDelegate,
                              BannerInfoCellViewModelDelegate, ButtonCellViewModelDelegate {
    func iconInfoCardTapped(_ cellViewModel: IconInfoCardCellViewModel) {
        viewModel.showAssetDetail(assetCode: cellViewModel.assetCode)
    }

    func sectionLabelActionTapped(_ cellViewModel: SectionLabelCellViewModel) {
        viewModel.showExplore()
    }

    func bannerInfoTapped(_ cellViewModel: BannerInfoCellViewModel) {
        viewModel.bannerTapped()
    }

    func buttonTapped(_ cellViewModel: ButtonCellViewModel) {
        viewModel.showCreatePortfolio()
    }
}
