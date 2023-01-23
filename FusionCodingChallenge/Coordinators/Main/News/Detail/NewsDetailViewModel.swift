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

    var title: Observable<String?> { get }
    var url: Observable<String?> { get }
    
}

class NewsDetailViewModel: NewsDetailViewModelProtocol {

    private var publication = BehaviorRelay<Publication?>(value: nil)

    private var _title = BehaviorRelay<String?>(value: nil)
    var title: Observable<String?> {
        return _title.asObservable()
    }

    private var _url = BehaviorRelay<String?>(value: nil)
    var url: Observable<String?> {
        return _url.asObservable()
    }

    func setup(publication: Publication) -> Self {

        self.publication.accept(publication)

        self._title.accept(publication.newsSite)
        self._url.accept(publication.url)

        return self

    }

}
