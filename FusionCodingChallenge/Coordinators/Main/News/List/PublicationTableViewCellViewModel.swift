//
//  PublicationTableViewCellViewModel.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/22/23.
//

import Foundation
import RxSwift
import RxCocoa

protocol PublicationTableViewCellViewModelProtocol {

    var title: Observable<String?> { get }
    var date: Observable<String?> { get }
    var imgUrl: Observable<String?> { get }

}

class PublicationTableViewCellViewModel {

    private var publication = BehaviorRelay<Publication?>(value: nil)

    private var _title = BehaviorRelay<String?>(value: nil)
    var title: Observable<String?> {
        return self._title.asObservable()
    }

    private var _date = BehaviorRelay<String?>(value: nil)
    var date: Observable<String?> {
        return self._date.asObservable()
    }

    private var _imgUrl = BehaviorRelay<String?>(value: nil)
    var imgUrl: Observable<String?> {
        return self._imgUrl.asObservable()
    }

    func setup(publication: Publication,
               dateTimeService: DateTimeServiceProtocol) -> Self {

        self.publication.accept(publication)

        self._title.accept(publication.title)
        self._imgUrl.accept(publication.imageUrl)

        self._date.accept(dateTimeService.formattedDateString(
            date: publication.publishedAt,
            format: .longMonthDateYear
        ))

        return self

    }

}
