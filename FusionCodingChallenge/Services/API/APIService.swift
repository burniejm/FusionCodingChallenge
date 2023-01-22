//
//  APIService.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/20/23.
//

import Foundation
import Alamofire

protocol APIServiceProtocol {

    func getPublications(
        type: PublicationType,
        start: Int?,
        limit: Int?,
        completion: @escaping (Result<[Publication], Error>) -> Void
    )

    func getPublication(
        type: PublicationType,
        id: Int,
        completion: @escaping (Result<[Publication], Error>) -> Void
    )

}

enum PublicationType: String {

    case articles = "Space News"
    case blogs = "Space Blogs"
    case reports = "Space Reports"

    private func path(id: Int? = nil) -> String {

        switch self {

        case .articles:

            if let id {
                return "articles/\(id)"
            }

            return "articles"

        case .blogs:

            if let id {
                return "blogs/\(id)"
            }

            return "blogs"

        case .reports:

            if let id {
                return "reports/\(id)"
            }

            return "reports"

        }

    }

    func url(baseUrl: String, id: Int? = nil) -> String {
        return baseUrl + path(id: id)
    }
}

struct APIError: Error, Decodable {

    let message: String
    let code: String
    let args: [String]

}

enum ArticlesParam: String {
    case start = "_start"
    case limit = "_limit"
    case contains = "_contains"
}

class APIService: APIServiceProtocol {

    private var baseURLString: String {
        "https://api.spaceflightnewsapi.net/v3/"
    }

    func getPublications(type: PublicationType,
                         start: Int?,
                         limit: Int?,
                         completion: @escaping (Result<[Publication], Error>) -> Void) {

        let requestParams = translateParams(
            start: start,
            limit: limit
        )

        AF.request(
            type.url(baseUrl: self.baseURLString),
            parameters: requestParams
        )
        .validate()
        .customResponseDecodable(
            of: [Publication].self) { response in
                switch response {

                case .success(let items):
                    completion(.success(items))

                case .failure(let error):
                    completion(.failure(error))
                }
            }

    }

    func getPublication(type: PublicationType,
                        id: Int,
                        completion: @escaping (Result<[Publication], Error>) -> Void) {

    }

    private func translateParams(start: Int?,
                                 limit: Int?) -> [String: AnyObject] {

        var requestParams = [String: AnyObject]()

        if let start {
            requestParams[ArticlesParam.start.rawValue] = start as AnyObject
        }

        if let limit {
            requestParams[ArticlesParam.limit.rawValue] = limit as AnyObject
        }

        return requestParams

    }

}
