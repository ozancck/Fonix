//
//  HomeCoordinator.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit
import Swinject

final class ExploreCoordinator: Coordinator {
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
        let viewModel = ExploreViewModel(service: service, navigator: self)
        let controller = ExploreViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: false)
    }
}

extension ExploreCoordinator: ExploreNavigating {
    func showAssetDetail(assetCode: String) {
        AppLog.verbose("Fon detayı: \(assetCode)")        // issue #10
    }

    func showCategory(code: String) {
        AppLog.verbose("Kategori: \(code)")               // kategori listesi ekranı sonra
    }

    func showAllFunds(type: TopFundType) {
        AppLog.verbose("Tüm fonlar: \(type.rawValue)")    // fon listesi ekranı sonra
    }
}
