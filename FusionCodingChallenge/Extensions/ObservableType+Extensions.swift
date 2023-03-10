//
//  ObservableType+Extensions.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/21/23.
//

import RxSwift
import RxCocoa

public extension ObservableType /* Value */ {

    /// Latest value of the observable sequence.
    var value: Self.Element {

        var value: Self.Element!
        let disposeBag = DisposeBag()

        subscribe(onNext: { _value in
            value = _value
        })
        .disposed(by: disposeBag)

        return value

    }

}
