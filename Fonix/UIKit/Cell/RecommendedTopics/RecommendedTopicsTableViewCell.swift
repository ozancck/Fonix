//
//  RecommendedTopicsTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class RecommendedTopicsTableViewCell: BaseTableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!

    private let itemReuseIdentifier = "RecommendedTopicCollectionViewCell"
    private var topicsViewModel: RecommendedTopicsCellViewModel?

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
        guard let viewModel = viewModel as? RecommendedTopicsCellViewModel else { return }
        topicsViewModel = viewModel
        collectionView.reloadData()
    }

    override func clearView() {
        super.clearView()
        topicsViewModel = nil
    }

    // MARK: UICollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        topicsViewModel?.items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemReuseIdentifier, for: indexPath)
        if let cell = cell as? RecommendedTopicCollectionViewCell, let item = topicsViewModel?.items[indexPath.item] {
            cell.set(item: item)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 64, height: 84)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: AppConstants.Margin2x, bottom: 0, right: AppConstants.Margin2x)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        topicsViewModel?.lineSpacing ?? AppConstants.Margin2x
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        topicsViewModel?.interitemSpacing ?? AppConstants.Margin2x
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let topicsViewModel else { return }
        topicsViewModel.selectedIndex = indexPath.item
        (collectionView.cellForItem(at: indexPath) as? RecommendedTopicCollectionViewCell)?.containerView.bounce()
        topicsViewModel.actionDelegate?.recommendedTopicTapped(topicsViewModel, at: indexPath.item)
    }
}
