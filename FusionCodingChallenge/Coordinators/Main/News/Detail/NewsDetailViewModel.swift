//
//  NewsDetailViewModel.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/21/23.
//

import Foundation
import RxSwift
import RxCocoa

protocol NewsDetailViewModelProtocol {
    var publication: Observable<Publication?> { get }
}

class NewsDetailViewModel: NewsDetailViewModelProtocol {

    private var _publication = BehaviorRelay<Publication?>(value: nil)
    var publication: Observable<Publication?> {
        return _publication.asObservable()
    }

    func setup(publication: Publication) -> Self {

        self._publication.accept(publication)

        return self

    }

}
