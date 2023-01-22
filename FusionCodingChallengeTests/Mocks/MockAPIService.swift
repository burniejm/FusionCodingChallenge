//
//  MockAPIService.swift
//  FusionCodingChallengeTests
//
//  Created by John Macy on 1/22/23.
//

import XCTest
@testable import FusionCodingChallenge

class MockApiService: APIServiceProtocol {

    private(set) var getPublicationsWasCalled = false
    private(set) var getPublicationsStartValue: Int?
    private(set) var getPublicationsLimitValue: Int?
    private(set) var getPublicationsCallCount = 0

    private(set) var getPublicationWasCalled = false

    var forceFailure: Bool = false

    func getPublications(type: FusionCodingChallenge.PublicationType,
                         start: Int?,
                         limit: Int?,
                         completion: @escaping (Result<[FusionCodingChallenge.Publication], Error>) -> Void) {

        getPublicationsWasCalled = true
        getPublicationsStartValue = start
        getPublicationsLimitValue = limit
        getPublicationsCallCount += 1

        completion(mockResponse(forceFailure: forceFailure))

    }

    func getPublication(type: FusionCodingChallenge.PublicationType,
                        id: Int,
                        completion: @escaping (Result<[FusionCodingChallenge.Publication], Error>) -> Void) {

        getPublicationWasCalled = true

    }

    private func mockResponse(forceFailure: Bool) -> Result<[FusionCodingChallenge.Publication], Error> {

        if forceFailure {

            return .failure(

                NSError(
                    domain: "FusionAllianceTest",
                    code: 500,
                    userInfo: nil
                )

            )

        }

        return .success([Publication.publication])

    }

}
