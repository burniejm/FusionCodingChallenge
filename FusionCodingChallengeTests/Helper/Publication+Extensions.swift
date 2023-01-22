//
//  Publication+Extensions.swift
//  FusionCodingChallengeTests
//
//  Created by John Macy on 1/22/23.
//

import Foundation
@testable import FusionCodingChallenge

extension Publication {

    static var publication: Publication {

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .customISO8601

        return try! decoder.decode(
            Publication.self,
            from: Publication.publicationJson
                .data(using: .utf8)!
        )

    }

    static var publicationJson: String {

        """
        {
            "id":123,
            "title":"title",
            "url":"url",
            "imageUrl":"imageUrl",
            "newsSite":"newsSite",
            "summary":"summary",
            "publishedAt":"2023-01-01T00:00:01.000Z",
            "updatedAt":"2023-01-01T00:00:01.000Z",
            "featured":false,
            "launches":[],
            "events":[]
        }
        """

    }

}
