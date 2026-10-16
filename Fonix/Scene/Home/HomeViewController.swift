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
        if viewModel.state != .loaded { return }
        let formatter = viewModel.formatter

        //////////////////////////// MARK: - Sana özel

        viewModels.append(SectionLabelCellViewModel(title: "home_for_you_title".localized))

        let topics = RecommendedTopicsCellViewModel(items: [
        RecommendedTopicItem(title: "home_topic_intro".localized),
        RecommendedTopicItem(title: "home_topic_funds".localized),
        RecommendedTopicItem(title: "home_topic_markets".localized)
        ])
        topics.actionDelegate = self
        viewModels.append(topics)

        //////////////////////////// MARK: - Portföyüm

        viewModels.append(SectionLabelCellViewModel(title: "home_portfolio_title".localized))

        if let home = viewModel.home,
           viewModel.hasPortfolio {
            var rows: [BaseCellViewModel] = []
            for asset in home.userAssets {
                let isExpanded = viewModel.expandedAssetTypes.contains(asset.assetType)
                let header = ExpandHeaderCellViewModel(title: "asset_type_\(asset.assetType)".localized,
                                                                   subtitle: "\(asset.items.count) " + "asset_item_count".localized,
                                                                   value: formatter.moneyString(asset.totalAmount),
                                                                   iconName: "Briefcase",
                                                                   isExpanded: isExpanded)
                header.identifier = asset.assetType
                if let url = asset.iconURL {
                    header.icon.source = .remote(url)
                }
                header.icon.cornerRadius = 20
                header.icon.contentMode = .scaleAspectFill
                header.separator = CellSeparator()
                header.actionDelegate = self
                rows.append(header)

                if isExpanded {
                    for item in asset.items {
                        let row = ExpandItemCellViewModel(title: item.assetCode,
                                                          subtitle: "asset_type_\(item.assetType)".localized,
                                                          value: "\(item.quantity) " + "asset_quantity".localized,
                                                          ratio: formatter.percentString(asset.totalPercentage),
                                                          isGain: asset.totalPercentage >= 0)
                        row.identifier = item.assetCode
                        row.separator = CellSeparator()
                        row.actionDelegate = self
                        rows.append(row)
                    }
                }
            }
            let create = ButtonCellViewModel(title: "home_portfolio_create".localized, iconName: "CaretRight")
            create.actionDelegate = self
            rows.append(create)
            viewModels.append(ContainerCellViewModel(viewModels: rows))
        } else {
            let banner = BannerActionCellViewModel(title: "home_portfolio_empty_title".localized,
                                                             detail: "home_portfolio_empty_detail".localized,
                                                             actionTitle: "home_portfolio_create".localized)
            banner.actionDelegate = self
            viewModels.append(banner)
        }

        //////////////////////////// MARK: - En çok kazandıranlar

        if !viewModel.earnerTypes.isEmpty {
                    let items = viewModel.earnerTypes.map {
                        ScrollSegmentItem(identifier: $0, title: "asset_type_\($0)".localized, iconName: "Briefcase")
                    }
                    let selected = viewModel.earnerTypes.firstIndex { $0 == viewModel.selectedEarnerType } ?? 0
                    let segment = ScrollSegmentCellViewModel(items: items, selectedIndex: selected)
                    segment.actionDelegate = self
                    viewModels.append(segment)
                }

        let earnersHeader = SectionLabelCellViewModel(title: "home_top_earners_title".localized,
                                                      actionTitle: "see_all".localized)
        earnersHeader.actionDelegate = self
        viewModels.append(earnersHeader)

        if viewModel.filteredTopEarners.isEmpty {
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

        //////////////////////////// MARK: - Haberler

        let newsHeader = SectionLabelCellViewModel(title: "home_news_title".localized,
                                                         actionTitle: "see_all".localized)
        newsHeader.actionDelegate = self
        viewModels.append(newsHeader)

        let article = ArticleCardCellViewModel(date: "16 Eki 2026",
                                                     category: "Fon",
                                                     title: "2026'da izlenecek fonlar",
                                                     detail: "Yılın ilk yarısında öne çıkan fon tipleri ve nedenleri.",
                                                     imageName: "Frame",
                                                     marketInfo: "AFT +2.1%",
                                                     viewsCount: "21.158",
                                                     likesCount: "22")
        article.actionDelegate = self
        viewModels.append(article)

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
                              BannerInfoCellViewModelDelegate, ButtonCellViewModelDelegate,
                              BannerActionCellViewModelDelegate, ExpandHeaderCellViewModelDelegate,
                              ExpandItemCellViewModelDelegate, ScrollSegmentCellViewModelDelegate,
                              RecommendedTopicsCellViewModelDelegate, ArticleCardCellViewModelDelegate {
    func bannerActionTapped(_ viewModel: BannerActionCellViewModel) {
        self.viewModel.showCreatePortfolio()
    }

    func expandCardHeaderTapped(_ viewModel: ExpandHeaderCellViewModel) {
        self.viewModel.toggleExpanded(assetType: viewModel.identifier)
    }

    func expandCardItemTapped(_ viewModel: ExpandItemCellViewModel) {
        self.viewModel.showAssetDetail(assetCode: viewModel.identifier)
    }

    func scrollSegmentTapped(_ viewModel: ScrollSegmentCellViewModel) {
        if let type = viewModel.selectedItem?.identifier {
            self.viewModel.selectEarnerType(type)
        }
    }
    func recommendedTopicTapped(_ viewModel: RecommendedTopicsCellViewModel, at index: Int) {
        self.viewModel.showExplore()
    }

    func articleCardTapped(_ viewModel: ArticleCardCellViewModel) {
        self.viewModel.showExplore()
    }

    func articleCardMoreTapped(_ viewModel: ArticleCardCellViewModel) {

    }

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
