//
//  DashboardCoordinator.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

final class DashboardCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController

    private let dependencies: AppDependencies
    private(set) weak var dashboard: DashboardViewController?

    init(navigationController: UINavigationController, dependencies: AppDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let controller = DashboardViewController()
        controller.viewControllers = DashboardTab.allCases.map { makeTab($0) }
        dashboard = controller
        navigationController.setViewControllers([controller], animated: false)
    }

    func show(_ tab: DashboardTab) {
        dashboard?.select(tab)
    }

    private func makeTab(_ tab: DashboardTab) -> UINavigationController {
        let navigation = UINavigationController()
        navigation.tabBarItem = tab.tabBarItem
        let coordinator: Coordinator
        switch tab {
        case .home: coordinator = HomeCoordinator(navigationController: navigation, dependencies: dependencies)
        case .portfolio: coordinator = PortfolioCoordinator(navigationController: navigation, dependencies: dependencies)
        case .explore: coordinator = ExploreCoordinator(navigationController: navigation, dependencies: dependencies)
        case .profile: coordinator = ProfileCoordinator(navigationController: navigation, dependencies: dependencies)
        }
        addChild(coordinator)
        coordinator.start()
        return navigation
    }
}
