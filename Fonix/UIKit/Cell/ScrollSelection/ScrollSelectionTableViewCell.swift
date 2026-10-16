//
//  ScrollSelectionTableViewCell.swift
//  Fonix
//
//  Created by Ozan on 16.10.2026.
//

import Foundation
import UIKit

final class ScrollSelectionTableViewCell: BaseTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!

    private let itemReuseIdentifier = "ScrollSelectionCollectionViewCell"
    private var selectionViewModel: ScrollSelectionCellViewModel?

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
        guard let viewModel = viewModel as? ScrollSelectionCellViewModel else { return }
        selectionViewModel = viewModel
        collectionView.reloadData()
    }

    override func clearView() {
        super.clearView()
        selectionViewModel = nil
    }

    // MARK: UICollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectionViewModel?.items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemReuseIdentifier, for: indexPath)
        if let cell = cell as? ScrollSelectionCollectionViewCell, let selectionViewModel {
            cell.set(item: selectionViewModel.items[indexPath.item], multiSelection: selectionViewModel.multiSelection)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectionViewModel else { return }
        (collectionView.cellForItem(at: indexPath) as? ScrollSelectionCollectionViewCell)?.containerView.bounce()
        selectionViewModel.toggle(index: indexPath.item)
        collectionView.reloadData()
        selectionViewModel.actionDelegate?.scrollSelectionChanged(selectionViewModel)
    }
}
