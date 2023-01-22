//
//  AFDecodableResponseSerializer.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/21/23.
//

/*
 https://medium.com/@charlesmuchene/custom-response-handler-in-alamofire-80267c3773a9
 https://stackoverflow.com/questions/64557970/how-to-decode-the-body-of-an-error-in-alamofire-5
 */

import Alamofire
import Foundation

final class CustomResponseSerializer<T: Decodable>: ResponseSerializer {

    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .customISO8601
        return decoder
    }()

    private lazy var successSerializer = DecodableResponseSerializer<T>(decoder: decoder)
    private lazy var errorSerializer = DecodableResponseSerializer<APIError>(decoder: decoder)

    public func serialize(request: URLRequest?,
                          response: HTTPURLResponse?,
                          data: Data?,
                          error: Error?) throws -> Result<T, APIError> {

        guard error == nil else {

            return .failure(APIError(
                message: "Unknown error",
                code: "unknown",
                args: [])
            )

        }

        guard let response = response else {

            return .failure(APIError(
                message: "Empty response",
                code: "empty_response",
                args: [])
            )

        }

        do {
            if response.statusCode < 200 || response.statusCode >= 300 {

                let result = try errorSerializer.serialize(
                    request: request,
                    response: response,
                    data: data,
                    error: nil
                )

                return .failure(result)

            } else {

                let result = try successSerializer.serialize(
                    request: request,
                    response: response,
                    data: data,
                    error: nil
                )

                return .success(result)

            }
        } catch(let err) {

            return .failure(APIError(
                message: err.localizedDescription,
                code: "",
                args: [String(data: data!, encoding: .utf8)!, err.localizedDescription])
            )

        }

    }

}

extension DataRequest {

    @discardableResult func customResponseDecodable<T: Decodable>(
        queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated),
        of t: T.Type,
        completionHandler: @escaping (Result<T, APIError>) -> Void) -> Self {

            return response(
                queue: .main,
                responseSerializer: CustomResponseSerializer<T>()) { response in

                    switch response.result {

                    case .success(let result):
                        completionHandler(result)

                    case .failure(let error):
                        completionHandler(
                            .failure(
                                APIError(
                                    message: "Other error",
                                    code: "other",
                                    args: [error.localizedDescription])
                            )
                        )
                    }

            }
        }
}

/*
 https://www.appsloveworld.com/swift/100/3/how-to-convert-a-date-string-with-optional-fractional-seconds-using-codable-in-sw
 */

extension Formatter {

    static let iso8601withFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

}

extension JSONDecoder.DateDecodingStrategy {

    static let customISO8601 = custom {

        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)

        if let date = Formatter.iso8601withFractionalSeconds.date(from: string) ?? Formatter.iso8601.date(from: string) {
            return date
        }

        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }

}
