//
//  APIService.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/20/23.
//

import Foundation
import Alamofire

protocol APIServiceProtocol {

    func getArticles(
        start: Int?,
        limit: Int?,
        completion: @escaping (Result<[Publication], Error>) -> Void
    )

    func getArticle(
        id: Int,
        completion: @escaping (Result<Publication, Error>) -> Void
    )

    func getBlogs(
        start: Int?,
        limit: Int?,
        completion: @escaping (Result<[Publication], Error>) -> Void
    )

    func getBlog(
        id: Int,
        completion: @escaping (Result<Publication, Error>) -> Void
    )

    func getReports(
        start: Int?,
        limit: Int?,
        completion: @escaping (Result<[Publication], Error>) -> Void
    )

    func getReport(
        id: Int,
        completion: @escaping (Result<Publication, Error>) -> Void
    )

}

protocol Endpoint {
    var baseURLString: String { get }
    var path: String { get }
}

extension Endpoint {
    var url: String {
        return baseURLString + path
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

enum APIEndpoints: Endpoint {

    case articles(id: Int? = nil)
    case blogs(id: Int? = nil)
    case reports(id: Int? = nil)

    var baseURLString: String {
        "https://api.spaceflightnewsapi.net/v3/"
    }

    var path: String {

        switch self {

        case .articles(let id):

            if let id {
                return "articles/\(id)"
            }

            return "articles"

        case .blogs(let id):

            if let id {
                return "blogs/\(id)"
            }

            return "blogs"

        case .reports(let id):

            if let id {
                return "reports/\(id)"
            }

            return "reports"

        }

    }

}

class APIService: APIServiceProtocol {

    func getArticles(start: Int?,
                     limit: Int?,
                     completion: @escaping (Result<[Publication], Error>) -> Void) {

        let requestParams = translateParams(
            start: start,
            limit: limit
        )

        AF.request(
            APIEndpoints.articles().url,
            parameters: requestParams
        )
        .validate()
        .responseTwoDecodable(
            of: [Publication].self) { response in
                switch response {

                case .success(let items):
                    completion(.success(items))

                case .failure(let error):
                    completion(.failure(error))
                }
            }

    }

    func getArticle(id: Int,
                    completion: @escaping (Result<Publication, Error>) -> Void) {

        AF.request(APIEndpoints.articles(id: id).url)
            .validate()
            .responseTwoDecodable(
                of: Publication.self) { response in
                    switch response {

                    case .success(let items):
                        completion(.success(items))

                    case .failure(let error):
                        completion(.failure(error))
                    }
                }

    }

    func getBlogs(start: Int?,
                  limit: Int?,
                  completion: @escaping (Result<[Publication], Error>) -> Void) {

        let requestParams = translateParams(
            start: start,
            limit: limit
        )

        AF.request(
            APIEndpoints.blogs().url,
            parameters: requestParams
        )
        .validate()
        .responseTwoDecodable(
            of: [Publication].self) { response in
                switch response {

                case .success(let items):
                    completion(.success(items))

                case .failure(let error):
                    completion(.failure(error))
                }
            }

    }

    func getBlog(id: Int,
                 completion: @escaping (Result<Publication, Error>) -> Void) {

        AF.request(APIEndpoints.blogs(id: id).url)
            .validate()
            .responseTwoDecodable(
                of: Publication.self) { response in
                    switch response {

                    case .success(let items):
                        completion(.success(items))

                    case .failure(let error):
                        completion(.failure(error))
                    }
                }

    }

    func getReports(start: Int?,
                    limit: Int?,
                    completion: @escaping (Result<[Publication], Error>) -> Void) {

        let requestParams = translateParams(
            start: start,
            limit: limit
        )

        AF.request(
            APIEndpoints.reports().url,
            parameters: requestParams
        )
        .validate()
        .responseTwoDecodable(
            of: [Publication].self) { response in
                switch response {
                    
                case .success(let items):
                    completion(.success(items))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }

    }

    func getReport(id: Int,
                   completion: @escaping (Result<Publication, Error>) -> Void) {

        AF.request(APIEndpoints.reports(id: id).url)
            .validate()
            .responseTwoDecodable(
                of: Publication.self) { response in
                    switch response {

                    case .success(let items):
                        completion(.success(items))

                    case .failure(let error):
                        completion(.failure(error))
                    }
                }

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
