//
//  MockDateTimeService.swift
//  FusionCodingChallengeTests
//
//  Created by John Macy on 1/22/23.
//

import XCTest
@testable import FusionCodingChallenge

class MockDateTimeService: DateTimeServiceProtocol {

    var formattedDateStringWasCalled = false
    var formattedDateStringDateValue: Date? = nil
    var formattedDateStringFormatValue: FusionCodingChallenge.DateFormat? = nil
    var formattedDateStringReturnValue = ""

    func formattedDateString(date: Date,
                             format: FusionCodingChallenge.DateFormat) -> String? {

        self.formattedDateStringWasCalled = true
        self.formattedDateStringDateValue = date
        self.formattedDateStringFormatValue = format

        return self.formattedDateStringReturnValue

    }

}
