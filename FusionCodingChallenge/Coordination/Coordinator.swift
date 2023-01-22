//
//  Coordinator.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/20/23.
//

import UIKit

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var rootViewController: UIViewController? { get }
    func start()
}

public extension Coordinator {
    func addChildCoordinator(_ childCoordinator: Coordinator) {
        childCoordinators.append(childCoordinator)
    }

    func removeChildCoordinator(_ childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
    }
}
