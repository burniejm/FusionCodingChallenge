//
//  PublicationListViewModelTests.swift
//  FusionCodingChallengeTests
//
//  Created by John Macy on 1/22/23.
//

import XCTest
@testable import FusionCodingChallenge

final class PublicationListViewModelTests: XCTestCase {

    var viewModel: PublicationListViewModel!
    var mockApiService: MockApiService!
    var mockViewModelDelegate: MockPublicationListViewModelDelegate!

    override func setUpWithError() throws {

        mockApiService = MockApiService()
        mockViewModelDelegate = MockPublicationListViewModelDelegate()
        viewModel = PublicationListViewModel(apiService: mockApiService)

    }

    override func tearDownWithError() throws {

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
