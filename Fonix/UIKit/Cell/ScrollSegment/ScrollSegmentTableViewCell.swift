//
//  ScrollSegmentTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class ScrollSegmentTableViewCell: BaseTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!

    private let itemReuseIdentifier = "ScrollSegmentCollectionViewCell"
    private var segmentViewModel: ScrollSegmentCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: itemReuseIdentifier, bundle: .main), forCellWithReuseIdentifier: itemReuseIdentifier)
        collectionView.clipsToBounds = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func set(viewModel: BaseCellViewModel) {
        super.set(viewModel: viewModel)
        guard let viewModel = viewModel as? ScrollSegmentCellViewModel else { return }
        segmentViewModel = viewModel
        collectionView.reloadData()
        scrollToSelected(animated: false)
    }

    override func clearView() {
        super.clearView()
        segmentViewModel = nil
    }

    private func scrollToSelected(animated: Bool) {
        guard let segmentViewModel, segmentViewModel.selectedItem != nil else { return }
        let indexPath = IndexPath(item: segmentViewModel.selectedIndex, section: 0)
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        }
    }

    // MARK: UICollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        segmentViewModel?.items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemReuseIdentifier, for: indexPath)
        if let cell = cell as? ScrollSegmentCollectionViewCell, let item = segmentViewModel?.items[indexPath.item] {
            cell.set(item: item)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let segmentViewModel else { return }
        (collectionView.cellForItem(at: indexPath) as? ScrollSegmentCollectionViewCell)?.backgroundColorView.bounce()
        segmentViewModel.select(index: indexPath.item)
        collectionView.reloadData()
        scrollToSelected(animated: true)
        segmentViewModel.actionDelegate?.scrollSegmentTapped(segmentViewModel)
    }
}
