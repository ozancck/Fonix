//
//  AppCoordinatorTests.swift
//  FonixTests
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import XCTest
@testable import Fonix

final class AppCoordinatorTests: XCTestCase {
    func test_start_setsRootController() {
        let navigation = UINavigationController()
        let coordinator = AppCoordinator(navigationController: navigation,
                                         dependencies: AppDependencies.live())

        coordinator.start()

        XCTAssertEqual(navigation.viewControllers.count, 1)
    }
}

