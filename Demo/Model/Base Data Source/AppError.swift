//
//  AppError.swift
//  Demo
//
//  Created by Marco Ghaly on 11/11/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation

typealias DefaultAppError = AppError<String>

enum AppError<ErrorModel>: Error, LocalizedError where ErrorModel: Codable, ErrorModel: CustomStringConvertible {
    case invalidURL(urlString: String?)
    case invalidParameters
    case statusCode(code: Int?, errorModel: ErrorModel?)
    case decoding
    case general(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .statusCode( _, let errorModel):
            return errorModel?.description
        case .general(let error):
            return error.localizedDescription
        default:
            return generalErrorDescription
        }
    }
}
