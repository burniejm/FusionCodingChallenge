//
//  MockPublicationListViewModelDelegate.swift
//  FusionCodingChallengeTests
//
//  Created by John Macy on 1/22/23.
//

import XCTest
@testable import FusionCodingChallenge

class MockPublicationListViewModelDelegate: PublicationListViewModelDelegate {

    var apiRequestFailedWasCalled = false
    var apiRequestFailedWithMessageValue: String?

    var selectedPublicationWasCalled = false
    var selectedPublicationSelectedPublicationValue: Publication?

    func publicationListViewModel(_ viewModel: FusionCodingChallenge.PublicationListViewModelProtocol,
                                  apiRequestFailed withMessage: String) {

        apiRequestFailedWasCalled = true
        apiRequestFailedWithMessageValue = withMessage

    }

    func publicationListViewModel(_ viewModel: FusionCodingChallenge.PublicationListViewModelProtocol,
                                  selectedPublication: FusionCodingChallenge.Publication) {

        selectedPublicationWasCalled = true
        selectedPublicationSelectedPublicationValue = selectedPublication

    }

}
