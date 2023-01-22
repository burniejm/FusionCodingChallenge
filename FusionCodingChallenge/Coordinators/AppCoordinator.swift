//
//  AppCoordinator.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/20/23.
//

import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()

    var window: UIWindow?
    var rootViewController: UIViewController?

    public init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        showMainScreen()
    }
}

private extension AppCoordinator {
    func showMainScreen() {
        let coordinator = MainCoordinator(delegate: self)
        setRootCoordinator(coordinator)
    }

    func setRootCoordinator(_ coordinator: Coordinator) {
        addChildCoordinator(coordinator)
        coordinator.start()
        window?.rootViewController = coordinator.rootViewController
        window?.makeKeyAndVisible()
    }
}

// MARK: - Main Coordinator Delegate

extension AppCoordinator: MainCoordinatorDelegate {
}
