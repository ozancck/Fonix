//
//  HomeViewController.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

final class ExploreViewController: BaseFormViewController {
    private let viewModel: ExploreViewModel
    private var searchTask: Task<Void, Never>?
    private let searchDebounce: UInt64 = 300_000_000

    init(viewModel: ExploreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func screenIdentifier() -> String { "tab_explore" }
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

        //////////////////////////// MARK: - Üst sekme

        let tabs = ExploreViewModel.Segment.allCases.map {
            TabSegmentItem(identifier: $0.rawValue, title: $0.titleKey.localized)
        }
        let selectedTab = ExploreViewModel.Segment.allCases.firstIndex(of: viewModel.selectedSegment) ?? 0
        let tabSegment = TabSegmentCellViewModel(items: tabs, selectedIndex: selectedTab)
        tabSegment.actionDelegate = self
        viewModels.append(tabSegment)

        guard viewModel.selectedSegment == .fund else {
            viewModels.append(BannerInfoCellViewModel(title: "explore_coming_soon".localized,
                                                      detail: "explore_segment_coming_soon_detail".localized,
                                                      actionTitle: "explore_segment_fund".localized))
            (viewModels.last as? BannerInfoCellViewModel)?.actionDelegate = self
            return
        }

        //////////////////////////// MARK: - Arama

        let search = SearchTextFieldCellViewModel(placeholder: "explore_search_placeholder".localized,
                                                  value: viewModel.searchQuery)
        search.searchDelegate = self
        viewModels.append(search)

        if viewModel.isSearching {
            viewModels.append(SectionLabelCellViewModel(title: "explore_search_results_title".localized))
            if viewModel.searchResults.isEmpty {
                viewModels.append(emptyBanner(title: "explore_search_empty".localized))
            } else {
                viewModels.append(ContainerCellViewModel(viewModels: assetRows(viewModel.searchResults)))
            }
            return
        }

        //////////////////////////// MARK: - Kategoriler

        if !viewModel.categories.isEmpty {
            viewModels.append(SectionLabelCellViewModel(title: "explore_categories_title".localized))
            let items = viewModel.categories.map { category -> ScrollSelectionItem in
                let item = ScrollSelectionItem(identifier: category.categoryCode,
                                               title: category.categoryTitle,
                                               iconName: "Briefcase")
                item.selected = category.categoryCode == viewModel.selectedCategoryCode
                return item
            }
            let selection = ScrollSelectionCellViewModel(items: items)
            selection.actionDelegate = self
            viewModels.append(selection)
        }

        //////////////////////////// MARK: - Keşfet

        let exploreHeader = SectionLabelCellViewModel(title: "explore_title".localized,
                                                      actionTitle: "see_all".localized)
        exploreHeader.actionDelegate = self
        viewModels.append(exploreHeader)

        let typeItems = TopFundType.allCases.map {
            ScrollSegmentItem(identifier: $0.rawValue, title: $0.titleKey.localized, iconName: "Briefcase")
        }
        let selectedType = TopFundType.allCases.firstIndex(of: viewModel.selectedTopFundType) ?? 0
        let typeSegment = ScrollSegmentCellViewModel(items: typeItems, selectedIndex: selectedType)
        typeSegment.actionDelegate = self
        viewModels.append(typeSegment)

        if viewModel.topFunds.isEmpty {
            viewModels.append(emptyBanner(title: "explore_top_funds_empty".localized))
        } else {
            var rows = assetRows(viewModel.topFunds)
            let seeAll = ButtonCellViewModel(title: "see_all".localized, iconName: "CaretRight")
            seeAll.actionDelegate = self
            rows.append(seeAll)
            viewModels.append(ContainerCellViewModel(viewModels: rows))
        }

        //////////////////////////// MARK: - Net nakit girişi (şimdilik sabit veri)

        viewModels.append(SectionLabelCellViewModel(title: "explore_net_cash_inflow_title".localized))
        let trends = TrendInfoCarouselCellViewModel(items: [
            TrendInfoCardItem(title: "FEI", ratio: "+₺312 mln", value: "1.83%", isGain: false),
            TrendInfoCardItem(title: "LUNO", ratio: "+₺215 mln", value: "0.94%", isGain: true),
            TrendInfoCardItem(title: "AFT", ratio: "+₺180 mln", value: "0.71%", isGain: true)
        ])
        trends.actionDelegate = self
        viewModels.append(trends)

        viewModels.append(SectionLabelCellViewModel(title: "explore_net_cash_inflow_category_title".localized))
        let categoryRows: [BaseCellViewModel] = [
            ("Para Piyasası", "+₺15.2 milyar", "Coins"),
            ("Hisse Senedi", "+₺10.1 milyar", "Network"),
            ("Değişken", "+₺5.3 milyar", "ChartLine"),
            ("Borçlanma Araçları", "+₺2.1 milyar", "ImageSquare"),
            ("Katılım", "+₺1.1 milyar", "VirtualReality")
        ].map { title, value, icon in
            let row = CategoryItemCellViewModel(title: title, value: value, iconName: icon)
            row.actionDelegate = self
            return row
        }
        viewModels.append(ContainerCellViewModel(viewModels: categoryRows))

        //////////////////////////// MARK: - Yeni fonlar (şimdilik sabit veri)

        viewModels.append(SectionLabelCellViewModel(title: "explore_new_funds_title".localized))
        let newFunds = (0 ..< 3).map { index -> BaseCellViewModel in
            let row = IconInfoCardCellViewModel(assetCode: "OJK",
                                                title: "OJK",
                                                subtitle: "Altın Fonu",
                                                value: "explore_annual_fee".localized + ": 1.85%",
                                                ratio: "1000%",
                                                isGain: true)
            if index < 2 { row.separator = CellSeparator() }
            row.actionDelegate = self
            return row
        }
        viewModels.append(ContainerCellViewModel(viewModels: newFunds))

        //////////////////////////// MARK: - Yakında (şimdilik sabit veri)

        viewModels.append(SectionLabelCellViewModel(title: "explore_coming_soon".localized))
        let soon = (0 ..< 3).map { index -> BaseCellViewModel in
            let row = ImageTitleCardCellViewModel(title: "Robotik ve Blockchain Teknolojileri Serbest Fon",
                                                  subtitle: "QNB Portföy",
                                                  imageName: "Frame")
            if index < 2 { row.separator = CellSeparator() }
            return row
        }
        viewModels.append(ContainerCellViewModel(viewModels: soon))
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
                                             detail: "explore_empty_detail".localized,
                                             actionTitle: "see_all".localized)
        banner.actionDelegate = self
        return banner
    }

    private func render() {
        reloadContent()
        if let message = viewModel.takeError() {
            showError(message)
        }
        if case .failed(let message) = viewModel.state {
            endRefreshing()
            showError(message)
        } else if viewModel.state == .loaded {
            endRefreshing()
        }
    }
}

extension ExploreViewController: TabSegmentCellViewModelDelegate, SearchTextFieldCellViewModelDelegate,
                                 ScrollSelectionCellViewModelDelegate, ScrollSegmentCellViewModelDelegate,
                                 SectionLabelCellViewModelDelegate, IconInfoCardCellViewModelDelegate,
                                 ButtonCellViewModelDelegate, BannerInfoCellViewModelDelegate,
                                 TrendInfoCarouselCellViewModelDelegate, CategoryItemCellViewModelDelegate {
    func tabSegmentTapped(_ viewModel: TabSegmentCellViewModel) {
        guard let identifier = viewModel.selectedItem?.identifier,
              let segment = ExploreViewModel.Segment(rawValue: identifier) else { return }
        self.viewModel.selectSegment(segment)
    }

    func searchTextDidChange(_ viewModel: SearchTextFieldCellViewModel) {
        let query = viewModel.value
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: self?.searchDebounce ?? 0)
            guard !Task.isCancelled else { return }
            await self?.viewModel.search(query: query)
        }
    }

    func scrollSelectionChanged(_ viewModel: ScrollSelectionCellViewModel) {
        if let code = viewModel.selectedItem?.identifier {
            self.viewModel.selectCategory(code: code)
        }
    }

    func scrollSegmentTapped(_ viewModel: ScrollSegmentCellViewModel) {
        guard let identifier = viewModel.selectedItem?.identifier,
              let type = TopFundType(rawValue: identifier) else { return }
        Task { await self.viewModel.selectTopFundType(type) }
    }

    func sectionLabelActionTapped(_ viewModel: SectionLabelCellViewModel) {
        self.viewModel.showAllFunds()
    }

    func iconInfoCardTapped(_ viewModel: IconInfoCardCellViewModel) {
        self.viewModel.showAssetDetail(assetCode: viewModel.assetCode)
    }

    func buttonTapped(_ viewModel: ButtonCellViewModel) {
        self.viewModel.showAllFunds()
    }

    func bannerInfoTapped(_ viewModel: BannerInfoCellViewModel) {
        if self.viewModel.selectedSegment != .fund {
            self.viewModel.selectSegment(.fund)
        } else {
            self.viewModel.showAllFunds()
        }
    }

    func trendInfoCardTapped(_ viewModel: TrendInfoCarouselCellViewModel, at index: Int) {
    }

    func categoryItemTapped(_ viewModel: CategoryItemCellViewModel) {
    }
}
