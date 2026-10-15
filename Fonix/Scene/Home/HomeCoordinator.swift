//
//  HomeCoordinator.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit
import Swinject

final class HomeCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController

    private let dependencies: AppDependencies

    init(navigationController: UINavigationController, dependencies: AppDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let service = dependencies.resolver.resolve(FundServicing.self)!
        let viewModel = HomeViewModel(service: service, navigator: self)
        let controller = HomeViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: false)
    }
}

extension HomeCoordinator: HomeNavigating {
    func showAssetDetail(assetCode: String) {
        AppLog.verbose("Fon detayı: \(assetCode)")   // issue #10
    }

    func showExplore() {
        (parentCoordinator as? DashboardCoordinator)?.show(.explore)
    }

    func showCreatePortfolio() {
        AppLog.verbose("Portföy oluştur")             // issue #11
    }
}
