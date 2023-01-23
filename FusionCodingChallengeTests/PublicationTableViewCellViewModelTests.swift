//
//  PublicationTableViewCellViewModelTests.swift
//  FusionCodingChallengeTests
//
//  Created by John Macy on 1/22/23.
//

import XCTest
@testable import FusionCodingChallenge

final class PublicationTableViewCellViewModelTests: XCTestCase {

    var viewModel: PublicationTableViewCellViewModel!
    var cell: PublicationTableViewCell!
    var mockDateTimeService: MockDateTimeService!

    override func setUpWithError() throws {

        self.viewModel = PublicationTableViewCellViewModel()
        self.cell = PublicationTableViewCell()
        self.mockDateTimeService = MockDateTimeService()

    }

    override func tearDownWithError() throws {

        self.viewModel = nil
        self.cell = nil

    }

    func testSetup() {

        let testDateString = "Test Date"
        self.mockDateTimeService.formattedDateStringReturnValue = testDateString

        self.viewModel.setup(
            publication: Publication.publication,
            dateTimeService: self.mockDateTimeService
        )

        self.cell.setup(viewModel: self.viewModel)

        XCTAssertEqual(self.viewModel.title.value, Publication.publication.title)
        XCTAssertEqual(self.viewModel.date.value, testDateString)
        XCTAssertEqual(self.viewModel.imgUrl.value, Publication.publication.imageUrl)

    }

}
