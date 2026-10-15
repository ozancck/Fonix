//
//  Coordinator.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

extension Coordinator {
    func addChild(_ coordinator: Coordinator) {
        coordinator.parentCoordinator = self
        children.append(coordinator)
    }

    func removeChild(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
    }
}
