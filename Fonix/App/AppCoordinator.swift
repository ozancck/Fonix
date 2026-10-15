//
//  AppCoordinator.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController

    private let dependencies: AppDependencies

    init(navigationController: UINavigationController = UINavigationController(),
         dependencies: AppDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        navigationController.navigationBar.prefersLargeTitles = false
    }

    func start() {
        let controller = UIViewController()
        controller.view.backgroundColor = .systemBackground
        controller.title = "Fonix"
        navigationController.setViewControllers([controller], animated: false)
    }
}
