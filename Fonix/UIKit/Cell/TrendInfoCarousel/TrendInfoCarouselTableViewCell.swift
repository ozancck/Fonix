//
//  TrendInfoCarouselTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class TrendInfoCarouselTableViewCell: BaseTableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collectionView: UICollectionView!

    private let itemReuseIdentifier = "TrendInfoCarouselCollectionViewCell"
    private var carouselViewModel: TrendInfoCarouselCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: itemReuseIdentifier, bundle: .main), forCellWithReuseIdentifier: itemReuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? TrendInfoCarouselCellViewModel else { return }
        carouselViewModel = viewModel
        collectionView.reloadData()
    }

    override func clearView() {
        super.clearView()
        carouselViewModel = nil
    }

    // MARK: UICollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        carouselViewModel?.items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemReuseIdentifier, for: indexPath)
        if let cell = cell as? TrendInfoCarouselCollectionViewCell, let item = carouselViewModel?.items[indexPath.item] {
            cell.set(item: item)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 160, height: 134)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let spacing = carouselViewModel?.lineSpacing ?? AppConstants.Margin2x
        return UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        carouselViewModel?.lineSpacing ?? AppConstants.Margin2x
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        carouselViewModel?.interitemSpacing ?? AppConstants.Margin2x
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let carouselViewModel else { return }
        carouselViewModel.selectedIndex = indexPath.item
        (collectionView.cellForItem(at: indexPath) as? TrendInfoCarouselCollectionViewCell)?.containerView.bounce()
        carouselViewModel.actionDelegate?.trendInfoCardTapped(carouselViewModel, at: indexPath.item)
    }
}
