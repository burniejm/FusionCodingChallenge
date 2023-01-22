//
//  Publication.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/20/23.
//

import Foundation

struct Publication: Codable, Comparable {

    static func < (lhs: Publication, rhs: Publication) -> Bool {
        lhs.publishedAt < rhs.publishedAt
    }

    static func == (lhs: Publication, rhs: Publication) -> Bool {
        lhs.id == rhs.id
    }


    let id: Int
    let title: String
    let url: String
    let imageUrl: String
    let newsSite: String
    let summary: String
    let publishedAt: Date
    let updatedAt: Date
    let featured: Bool?
    let launches: [Launch]?
    let events: [Event]?

}
