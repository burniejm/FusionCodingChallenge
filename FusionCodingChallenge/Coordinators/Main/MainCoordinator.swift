//
//  MainCoordinator.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/20/23.
//

import UIKit

protocol MainCoordinatorDelegate: AnyObject {
}

class MainCoordinator: Coordinator {

    weak var delegate: MainCoordinatorDelegate?

    var childCoordinators = [Coordinator]()
    var rootViewController: UIViewController? {
        return rootNavController
    }

    private lazy var rootNavController: UINavigationController? = {
        return UIStoryboard.main.instantiateInitialViewController() as? UINavigationController
    }()

    private var newsVC: NewsListViewController {

        let vm = PublicationListViewModel(apiService: APIService())
            .setup(delegate: self)

        let vc = NewsListViewController().setup(
            viewModel: vm,
            dateTimeService: DateTimeService()
        )

        return vc

    }

    public init(delegate: MainCoordinatorDelegate?) {
        self.delegate = delegate
    }

    func start() {
        restart()
    }

    private func restart() {
        self.rootNavController?.viewControllers = [self.newsVC]
    }

}

extension MainCoordinator: PublicationListViewModelDelegate {

    func publicationListViewModel(_ viewModel: PublicationListViewModelProtocol,
                       apiRequestFailed withMessage: String) {

        let alertController = UIAlertController(
            title: "Error",
            message: withMessage,
            preferredStyle: .alert
        )

        alertController.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        self.rootViewController?.present(
            alertController,
            animated: true,
            completion: nil
        )

    }

    func publicationListViewModel(_ viewModel: PublicationListViewModelProtocol,
                       selectedPublication: Publication) {

        let vm = NewsDetailViewModel()
            .setup(publication: selectedPublication)

        let vc = NewsDetailViewController()
            .setup(viewModel: vm)

        self.rootNavController?.pushViewController(
            vc,
            animated: true
        )

    }

}
