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

        self.mockApiService = MockApiService()
        self.mockViewModelDelegate = MockPublicationListViewModelDelegate()
        self.viewModel = PublicationListViewModel(apiService: mockApiService)

    }

    override func tearDownWithError() throws {

        self.mockApiService = nil
        self.mockViewModelDelegate = nil
        self.viewModel = nil

    }

    func testInit() {

        XCTAssertEqual(self.viewModel.publications.value.count, 0)
        XCTAssertFalse(self.viewModel.isLoading.value)
        XCTAssertEqual(self.viewModel.title.value, "")

    }

    func testTypeSetOnSetup() {

        self.viewModel.setup(
            type: .articles,
            delegate: nil
        )

        XCTAssertEqual(self.viewModel.type, .articles)

    }

    func testTitleSetOnSetup() {

        self.viewModel.setup(
            type: .articles,
            delegate: nil
        )

        XCTAssertEqual(self.viewModel.title.value, PublicationType.articles.rawValue)

    }

    func testLoadDataCalledOnSetup() {

        self.viewModel.setup(
            type: .articles,
            delegate: nil
        )

        XCTAssertTrue(self.mockApiService.getPublicationsWasCalled)
        XCTAssertNil(self.mockApiService.getPublicationsStartValue)
        XCTAssertEqual(self.mockApiService.getPublicationsLimitValue, self.viewModel.itemsPerRequest)

    }

    func testApiRequestFailedDelegate() {

        self.mockApiService.forceFailure = true
        self.viewModel.setup(
            type: .articles,
            delegate: self.mockViewModelDelegate
        )

        XCTAssertTrue(self.mockViewModelDelegate.apiRequestFailedWasCalled)

    }

    func testRefresh() {

        self.viewModel.setup(
            type: .articles,
            delegate: self.mockViewModelDelegate
        )

        XCTAssertEqual(self.mockApiService.getPublicationsCallCount, 1)

        self.viewModel.refreshTriggered()

        XCTAssertEqual(self.mockApiService.getPublicationsCallCount, 2)

    }

    func testFetchNextItems() {

        self.viewModel.setup(
            type: .articles,
            delegate: self.mockViewModelDelegate
        )

        XCTAssertNil(self.mockApiService.getPublicationsStartValue)
        XCTAssertEqual(self.mockApiService.getPublicationsLimitValue, self.viewModel.itemsPerRequest)
        XCTAssertEqual(self.mockApiService.getPublicationsCallCount, 1)

        self.viewModel.fetchNextItems()

        XCTAssertEqual(self.mockApiService.getPublicationsStartValue, self.viewModel.itemsPerRequest)
        XCTAssertEqual(self.mockApiService.getPublicationsLimitValue, self.viewModel.itemsPerRequest)
        XCTAssertEqual(self.mockApiService.getPublicationsCallCount, 2)

        self.viewModel.fetchNextItems()

        XCTAssertEqual(self.mockApiService.getPublicationsStartValue, 2 * self.viewModel.itemsPerRequest)
        XCTAssertEqual(self.mockApiService.getPublicationsLimitValue, self.viewModel.itemsPerRequest)
        XCTAssertEqual(self.mockApiService.getPublicationsCallCount, 3)

    }

    func testSelect() {

        self.viewModel.setup(
            type: .articles,
            delegate: self.mockViewModelDelegate
        )

        self.viewModel.select(itemAtIndex: 0)

        XCTAssertTrue(self.mockViewModelDelegate.selectedPublicationWasCalled)
        XCTAssertEqual(self.viewModel.publications.value[0], self.mockViewModelDelegate.selectedPublicationSelectedPublicationValue)

    }


}
