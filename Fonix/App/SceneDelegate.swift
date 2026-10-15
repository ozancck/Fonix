//
//  SceneDelegate.swift
//  Fonix
//
//  Created by Ozan on 15.10.2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let coordinator = AppCoordinator(dependencies: .live())
        coordinator.start()
        window.rootViewController = coordinator.navigationController
        window.makeKeyAndVisible()
        self.window = window
        self.appCoordinator = coordinator
    }
}
