//
//  DashboardCoordinatorTests.swift
//  FonixTests
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import XCTest
@testable import Fonix

final class DashboardCoordinatorTests: XCTestCase {
    private func makeStarted() -> (DashboardCoordinator, UINavigationController) {
        let navigation = UINavigationController()
        let coordinator = DashboardCoordinator(navigationController: navigation,
                                               dependencies: AppDependencies.live())
        coordinator.start()
        return (coordinator, navigation)
    }

    func test_start_buildsOneTabPerCase() {
        let (coordinator, navigation) = makeStarted()
        let dashboard = navigation.viewControllers.first as? DashboardViewController

        XCTAssertEqual(dashboard?.viewControllers?.count, DashboardTab.allCases.count)
        XCTAssertEqual(coordinator.children.count, DashboardTab.allCases.count)
    }

    func test_show_selectsTab() {
        let (coordinator, navigation) = makeStarted()
        let dashboard = navigation.viewControllers.first as? DashboardViewController

        coordinator.show(.explore)

        XCTAssertEqual(dashboard?.selectedIndex, DashboardTab.explore.rawValue)
    }

    func test_tabs_haveTitlesAndImages() {
        for tab in DashboardTab.allCases {
            let item = tab.tabBarItem
            XCTAssertFalse(item.title?.isEmpty ?? true, "\(tab) başlığı boş")
            XCTAssertNotNil(item.image, "\(tab) ikonu yok")
        }
    }
}
