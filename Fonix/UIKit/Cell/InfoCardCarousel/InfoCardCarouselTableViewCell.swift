//
//  InfoCardCarouselTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class InfoCardCarouselTableViewCell: BaseTableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!

    private let itemReuseIdentifier = "InfoCardCarouselCollectionViewCell"
    private var carouselViewModel: InfoCardCarouselCellViewModel?

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
        guard let viewModel = viewModel as? InfoCardCarouselCellViewModel else { return }
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
        if let cell = cell as? InfoCardCarouselCollectionViewCell, let item = carouselViewModel?.items[indexPath.item] {
            cell.set(item: item)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 144, height: 60)
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
        (collectionView.cellForItem(at: indexPath) as? InfoCardCarouselCollectionViewCell)?.containerView.bounce()
        carouselViewModel.actionDelegate?.infoCardTapped(carouselViewModel, at: indexPath.item)
    }
}
