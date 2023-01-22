//
//  PublicationListViewModel.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/21/23.
//

import Foundation
import RxSwift
import RxCocoa

protocol PublicationListViewModelDelegate: AnyObject {

    func publicationListViewModel(_ viewModel: PublicationListViewModelProtocol, apiRequestFailed withMessage: String)
    func publicationListViewModel(_ viewModel: PublicationListViewModelProtocol, selectedPublication: Publication)

}

protocol PublicationListViewModelProtocol {

    var title: Observable<String> { get }
    var publications: Observable<[Publication]> { get }
    var isLoading: Observable<Bool> { get }
    var infiniteScrollThreshold: Int { get }

    init(apiService: APIServiceProtocol)
    func setup(type: PublicationType, delegate: PublicationListViewModelDelegate?) -> Self
    func refreshTriggered()
    func fetchNextItems()
    func select(itemAtIndex: Int)

}

class PublicationListViewModel: PublicationListViewModelProtocol {

    static let itemsPerRequest = 20
    static let _infiniteScrollThreshold = 2

    private weak var delegate: PublicationListViewModelDelegate?

    private let apiService: APIServiceProtocol
    private(set) var type: PublicationType = .articles

    private var currentPage = 1

    private var _publications = BehaviorRelay<[Publication]>(value: [])
    var publications: Observable<[Publication]> {
        return _publications.asObservable()
    }

    private var _isLoading = BehaviorRelay<Bool>(value: false)
    var isLoading: Observable<Bool> {
        return _isLoading.asObservable()
    }

    private var _sortDesc = BehaviorRelay<Bool>(value: true)
    var sortDesc: Observable<Bool> {
        return _sortDesc.asObservable()
    }

    var title: Observable<String> {
        Observable.just("Space News")
    }

    var infiniteScrollThreshold: Int {
        Self._infiniteScrollThreshold
    }

    required init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    @discardableResult
    func setup(type: PublicationType,
               delegate: PublicationListViewModelDelegate?) -> Self {

        self.type = type
        self.delegate = delegate

        loadData()

        return self

    }

    func set(sortDesc: Bool) {
        self._sortDesc.accept(sortDesc)
    }

    func fetchNextItems() {

        guard !self.isLoading.value else { return }

        let start = self.currentPage * PublicationListViewModel.itemsPerRequest

        self.loadData(start: start) {
            self.currentPage += 1
        }

    }

    func select(itemAtIndex: Int) {

        let publication = self._publications.value[itemAtIndex]

        self.delegate?.publicationListViewModel(
            self,
            selectedPublication: publication
        )

    }

    func refreshTriggered() {
        self.loadData()
    }

    private func loadData(start: Int? = nil,
                          success:(() -> Void)? = nil) {

        self._isLoading.accept(true)

        self.apiService.getPublications(
            type: self.type,
            start: start,
            limit: PublicationListViewModel.itemsPerRequest) { [weak self] result in

                guard let self else { return }

                var tempPublications = self._publications.value

                switch result {

                case .success(let pubs):

                    for publication in pubs {

                        if !tempPublications.contains(where: { $0.id == publication.id }) {
                            tempPublications.append(publication)
                        }

                        self._publications.accept(tempPublications)

                        success?()

                    }

                    self._isLoading.accept(false)

                case .failure(_):

                    self.delegate?.publicationListViewModel(
                        self,
                        apiRequestFailed: "Failed loading \(self.type). Please try again."
                    )

                    self._isLoading.accept(false)

                }

            }


    }

}
