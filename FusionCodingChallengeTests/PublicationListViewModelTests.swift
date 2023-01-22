//
//  PublicationListViewModelTests.swift
//  FusionCodingChallengeTests
//
//  Created by John Macy on 1/22/23.
//

import XCTest
@testable import FusionCodingChallenge

class MockApiService: APIServiceProtocol {

    private(set) var getPublicationsWasCalled = false
    private(set) var getPublicationWasCalled = false

    func getPublications(type: FusionCodingChallenge.PublicationType,
                         start: Int?,
                         limit: Int?,
                         completion: @escaping (Result<[FusionCodingChallenge.Publication], Error>) -> Void) {

        getPublicationsWasCalled = true

    }

    func getPublication(type: FusionCodingChallenge.PublicationType,
                        id: Int,
                        completion: @escaping (Result<[FusionCodingChallenge.Publication], Error>) -> Void) {

        getPublicationWasCalled = true

    }


}

final class PublicationListViewModelTests: XCTestCase {

    var viewModel: PublicationListViewModel!
    var mockApiService: MockApiService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        mockApiService = MockApiService()
        viewModel = PublicationListViewModel(apiService: mockApiService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

        mockApiService = nil
        viewModel = nil

    }

    func testGetPublicationsCalledOnSetup() {

        viewModel.setup(type: .articles, delegate: nil)
        XCTAssertTrue(mockApiService.getPublicationsWasCalled)

    }

    func testTypeSetCorrectlyOnSetup() {

    }

}
