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

final class PublicationListViewModelTests: XCTestCase {

    var viewModel: PublicationListViewModel!
    var mockApiService: MockApiService!
    var mockViewModelDelegate: MockPublicationListViewModelDelegate!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        mockApiService = MockApiService()
        mockViewModelDelegate = MockPublicationListViewModelDelegate()
        viewModel = PublicationListViewModel(apiService: mockApiService)

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

        mockApiService = nil
        mockViewModelDelegate = nil
        viewModel = nil

    }

    func testInit() {

        XCTAssertEqual(viewModel.publications.value.count, 0)
        XCTAssertFalse(viewModel.isLoading.value)
        XCTAssertEqual(viewModel.title.value, "")

    }

    func testTypeSetOnSetup() {

        viewModel.setup(type: .articles, delegate: nil)
        XCTAssertEqual(viewModel.type, .articles)

    }

    func testTitleSetOnSetup() {

        viewModel.setup(type: .articles, delegate: nil)
        XCTAssertEqual(viewModel.title.value, PublicationType.articles.rawValue)

    }

    func testLoadDataCalledOnSetup() {

        viewModel.setup(type: .articles, delegate: nil)
        XCTAssertTrue(mockApiService.getPublicationsWasCalled)
        XCTAssertNil(mockApiService.getPublicationsStartValue)
        XCTAssertEqual(mockApiService.getPublicationsLimitValue, viewModel.itemsPerRequest)

    }

    func testApiRequestFailedDelegate() {

        mockApiService.forceFailure = true
        viewModel.setup(type: .articles, delegate: mockViewModelDelegate)
        XCTAssertTrue(mockViewModelDelegate.apiRequestFailedWasCalled)

    }

    func testRefresh() {

        viewModel.setup(type: .articles, delegate: mockViewModelDelegate)
        XCTAssertEqual(mockApiService.getPublicationsCallCount, 1)

        viewModel.refreshTriggered()
        XCTAssertEqual(mockApiService.getPublicationsCallCount, 2)

    }

    func testFetchNextItems() {

        viewModel.setup(type: .articles, delegate: mockViewModelDelegate)
        XCTAssertNil(mockApiService.getPublicationsStartValue)
        XCTAssertEqual(mockApiService.getPublicationsLimitValue, viewModel.itemsPerRequest)
        XCTAssertEqual(mockApiService.getPublicationsCallCount, 1)

        viewModel.fetchNextItems()
        XCTAssertEqual(mockApiService.getPublicationsStartValue, viewModel.itemsPerRequest)
        XCTAssertEqual(mockApiService.getPublicationsLimitValue, viewModel.itemsPerRequest)
        XCTAssertEqual(mockApiService.getPublicationsCallCount, 2)

        viewModel.fetchNextItems()
        XCTAssertEqual(mockApiService.getPublicationsStartValue, 2 * viewModel.itemsPerRequest)
        XCTAssertEqual(mockApiService.getPublicationsLimitValue, viewModel.itemsPerRequest)
        XCTAssertEqual(mockApiService.getPublicationsCallCount, 3)

    }

    func testSelect() {

        viewModel.setup(type: .articles, delegate: mockViewModelDelegate)
        viewModel.select(itemAtIndex: 0)
        XCTAssertTrue(mockViewModelDelegate.selectedPublicationWasCalled)
        XCTAssertEqual(viewModel.publications.value[0], mockViewModelDelegate.selectedPublicationSelectedPublicationValue)

    }


}
