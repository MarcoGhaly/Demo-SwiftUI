//
//  APIError.swift
//  Authentication
//
//  Created by Marco Ghaly on 16/03/2021.
//

import Foundation

typealias DefaultAPIError = APIError<String>

enum APIError<ErrorModel>: Error where ErrorModel: Decodable {
    case invalidURL
    case noInternet
    case timeout
    case statusCode(code: Int, errorModel: ErrorModel?)
    case decoding(rawResponse: String?)
    case general(error: Error)
    case unknownError
}
