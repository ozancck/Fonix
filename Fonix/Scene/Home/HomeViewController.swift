//
//  HomeViewController.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
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

    override func prepareViewModels() {
        viewModels = viewModel.makeCellViewModels()
        
        
    }

    override func didPullToRefresh() {
        Task { await viewModel.load() }
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
