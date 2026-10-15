//
//  DashboardViewController.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

final class DashboardViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func select(_ tab: DashboardTab) {
        selectedIndex = tab.rawValue
    }

    private func configureAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColor.gray90.uiColor
        appearance.shadowColor = AppColor.gray80.uiColor

        let normal = appearance.stackedLayoutAppearance.normal
        normal.iconColor = AppColor.gray50.uiColor
        normal.titleTextAttributes = [.foregroundColor: AppColor.gray50.uiColor,
                                      .font: AppFont.bodySmall.attributes(.medium).font]

        let selected = appearance.stackedLayoutAppearance.selected
        selected.iconColor = AppColor.brand50.uiColor
        selected.titleTextAttributes = [.foregroundColor: AppColor.gray0.uiColor,
                                        .font: AppFont.bodySmall.attributes(.bold).font]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = AppColor.brand50.uiColor
    }
}
