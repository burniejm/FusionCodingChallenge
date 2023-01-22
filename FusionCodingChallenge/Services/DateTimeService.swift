//
//  DateTimeService.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/21/23.
//

import Foundation

enum DateFormat {

    case longMonthDateYear
    case shortMonthDateYear

    var formatString: String {

        switch self {

        case .longMonthDateYear:
            return "MMMM d, yyyy"
        case .shortMonthDateYear:
            return "M/d/yyyy"
        }

    }

}

protocol DateTimeServiceProtocol {
    func formattedDateString(date: Date, format: DateFormat) -> String?
}

class DateTimeService: DateTimeServiceProtocol {

    private lazy var longMonthDateYearFormatter: DateFormatter = {

        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.longMonthDateYear.formatString
        return formatter

    }()

    private lazy var shortMonthDateYearFormatter: DateFormatter = {

        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.shortMonthDateYear.formatString
        return formatter

    }()

    func formattedDateString(date: Date, format: DateFormat) -> String? {

        var formatter: DateFormatter!

        switch format {
        case .shortMonthDateYear: formatter = self.shortMonthDateYearFormatter
        case .longMonthDateYear: formatter = self.longMonthDateYearFormatter
        }

        return formatter.string(from: date)

    }

}
