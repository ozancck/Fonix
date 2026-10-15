//
//  BaseViewController.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.gray90.uiColor
        configureNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBarButtons()
    }

    // MARK: Override noktaları

    func screenIdentifier() -> String { "" }

    func navigationTitle() -> String {
        screenIdentifier().isEmpty ? "" : screenIdentifier().localized
    }

    func navigationBackgroundColor() -> UIColor { AppColor.gray90.uiColor }
    func navigationTintColor() -> UIColor { AppColor.gray0.uiColor }
    func navigationTitleFont() -> UIFont { AppFont.h6.attributes(.bold).font }
    func hidesBackButton() -> Bool { false }

    // MARK: Navigation bar

    private func configureNavigationBar() {
        title = navigationTitle()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = navigationBackgroundColor()
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: navigationTintColor(),
                                          .font: navigationTitleFont()]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = navigationTintColor()
    }

    private func configureBarButtons() {
        navigationItem.hidesBackButton = true
        if let navigationController, navigationController.viewControllers.count > 1, !hidesBackButton() {
            navigationItem.leftBarButtonItem = barButton(named: "icon_back",
                                                         fallback: "chevron.left",
                                                         action: #selector(backButtonTapped))
        }
        if navigationController?.presentingViewController != nil {
            navigationItem.rightBarButtonItem = barButton(named: "icon_close",
                                                          fallback: "xmark",
                                                          action: #selector(closeButtonTapped))
        }
    }

    private func barButton(named name: String, fallback: String, action: Selector) -> UIBarButtonItem {
        let image = UIImage(named: name) ?? UIImage(systemName: fallback)
        return UIBarButtonItem(image: image?.withRenderingMode(.alwaysTemplate),
                               style: .plain, target: self, action: action)
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }

    // MARK: Alert

    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: .default) { _ in completion?() })
        present(alert, animated: true)
    }

    func showError(_ message: String) {
        showAlert(title: "error_title".localized, message: message)
    }

    deinit { AppLog.deinitialize(self) }
}
