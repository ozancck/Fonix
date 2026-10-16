//
//  BaseFormViewController.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

class BaseFormViewController: BaseViewController {
    let tableView = UITableView(frame: .zero, style: .plain)
    let headerStack = UIStackView()
    let footerStack = UIStackView()

    var viewModels = [BaseCellViewModel]()
    var headerViewModels = [BaseCellViewModel]()
    var footerViewModels = [BaseCellViewModel]()
    var headerCells = [BaseTableViewCell]()
    var footerCells = [BaseTableViewCell]()

    private var refreshControl: UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        hideKeyboardWhenTapped()
        reloadContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allViewModels.forEach { $0.cellWillAppear() }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        allViewModels.forEach { $0.cellWillDisappear() }
    }

    // MARK: Override noktaları

    /// Alt sınıf viewModels / headerViewModels / footerViewModels dizilerini burada doldurur.
    func prepareViewModels() {}

    func supportsPullToRefresh() -> Bool { false }
    func didPullToRefresh() {}
    func didSelect(viewModel: BaseCellViewModel, at indexPath: IndexPath) {}
    func didDelete(viewModel: BaseCellViewModel, at indexPath: IndexPath) {}

    // MARK: İçerik

    func reloadContent() {
        viewModels.removeAll()
        headerViewModels.removeAll()
        footerViewModels.removeAll()
        prepareViewModels()
        headerCells = fill(stack: headerStack, with: headerViewModels)
        footerCells = fill(stack: footerStack, with: footerViewModels)
        tableView.reloadData()
    }

    func viewModel(identifier: String) -> BaseCellViewModel? {
        allViewModels.first { $0.identifier == identifier }
    }

    func validateScreen() -> String? {
        view.endEditing(true)
        for viewModel in allViewModels where viewModel.visible {
            if let message = viewModel.validate() { return message }
        }
        return nil
    }

    func endRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
    }

    func clearViewModels() {
        allViewModels.forEach { $0.clearViewModel() }
        viewModels.removeAll()
        headerViewModels.removeAll()
        footerViewModels.removeAll()
        headerCells.removeAll()
        footerCells.removeAll()
    }

    private var allViewModels: [BaseCellViewModel] {
        headerViewModels + viewModels + footerViewModels
    }

    // MARK: Yerleşim

    private func buildLayout() {
        [headerStack, footerStack].forEach {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .equalSpacing
        }
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.keyboardDismissMode = .interactive
        tableView.dataSource = self
        tableView.delegate = self
        tableView.setContentHuggingPriority(.defaultLow, for: .vertical)
        tableView.setContentCompressionResistancePriority(.required, for: .vertical)
        headerStack.setContentHuggingPriority(.required, for: .vertical)
        footerStack.setContentHuggingPriority(.required, for: .vertical)

        for stack in [headerStack, footerStack] {
            let zero = stack.heightAnchor.constraint(equalToConstant: 0)
            zero.priority = .defaultLow
            zero.isActive = true
        }
        let container = UIStackView(arrangedSubviews: [headerStack, tableView, footerStack])
        container.axis = .vertical
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        if supportsPullToRefresh() {
            let control = UIRefreshControl()
            control.tintColor = AppColor.gray30.uiColor
            control.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
            tableView.refreshControl = control
            refreshControl = control
        }
    }

    private func fill(stack: UIStackView, with viewModels: [BaseCellViewModel]) -> [BaseTableViewCell] {
        stack.removeAllArrangedSubviews()
        var cells = [BaseTableViewCell]()
        for viewModel in viewModels {
            guard let cell = viewModel.makeCell() else { continue }
            viewModel.reloadDelegate = self
            viewModel.cell = cell
            cell.set(viewModel: viewModel)
            cells.append(cell)
            stack.addArrangedSubview(cell.contentView)
        }
        return cells
    }

    private func hideKeyboardWhenTapped() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func pullToRefresh() { didPullToRefresh() }

    deinit { NotificationCenter.default.removeObserver(self) }
}

// MARK: - UITableViewDataSource

extension BaseFormViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        guard let cell = viewModel.cell ?? viewModel.makeCell() else {
            AppLog.error("Hücre yüklenemedi: \(viewModel.cellIdentifier())")
            return UITableViewCell()
        }
        viewModel.reloadDelegate = self
        viewModel.cell = cell
        cell.indexPath = indexPath
        cell.isHidden = !viewModel.visible
        cell.set(viewModel: viewModel)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension BaseFormViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModels[indexPath.row].visible ? UITableView.automaticDimension : 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect(viewModel: viewModels[indexPath.row], at: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? BaseTableViewCell)?.cellWillDisplay()
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? BaseTableViewCell)?.cellDidEndDisplaying()
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let viewModel = viewModels[indexPath.row]
        guard viewModel.canDelete else { return nil }
        let delete = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, done in
            self?.viewModels.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self?.didDelete(viewModel: viewModel, at: indexPath)
            done(true)
        }
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = AppColor.destructive50.uiColor
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

// MARK: - CellReloading

extension BaseFormViewController: CellReloading {
    func reloadCell(_ viewModel: BaseCellViewModel) {
        guard let cell = viewModel.cell, let indexPath = tableView.indexPath(for: cell) else {
            viewModel.reloadContent()
            return
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    func reloadAllCells() {
        tableView.reloadData()
    }
}
