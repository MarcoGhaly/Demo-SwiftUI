//
//  BaseDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

enum AppError: Error {
    case invalidURL(urlString: String?)
    case statusCode(code: Int?)
    case decoding
    case general(error: Error)
}

class BaseDataSource {
    
    private static let baseURL = "https://jsonplaceholder.typicode.com/"
    private static let successCode = 200
    
    func performRequest<T: Codable>(withRelativeURL relativeURLString: String) -> AnyPublisher<T, AppError> {
        let urlString = BaseDataSource.baseURL + relativeURLString
        return performRequest(withURL: urlString)
    }
    
    func performRequest<T: Codable>(withURL urlString: String) -> AnyPublisher<T, AppError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: .invalidURL(urlString: urlString)).eraseToAnyPublisher()
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                let data = output.data
                let httpURLResponse = output.response as? HTTPURLResponse
                let statusCode = httpURLResponse?.statusCode
                if let statusCode = statusCode, statusCode == BaseDataSource.successCode {
                    return data
                }
                
                throw AppError.statusCode(code: statusCode)
        }
        .decode(type: T.self, decoder: jsonDecoder)
        .mapError({ (error) -> AppError in
            (error as? AppError) ?? AppError.general(error: error)
        })
            .eraseToAnyPublisher()
    }
    
    func performRequest<T: Codable>(urlString: String, completion: @escaping (DataResult<T>) -> Void) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(DataResult(success: false, data: nil, error: NSError()))
            }
            return
        }
        
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print("\(#function) -> Response:\n\(response)")
            }
            
            var result = DataResult<T>(success: false, data: nil, error: nil)
            
            if data == nil || error != nil {
                let error = error ?? NSError()
                result.error = error
            } else if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let posts = try jsonDecoder.decode(T.self, from: data)
                    result.success = true
                    result.data = posts
                    print("\(#function) -> Response Object:\n\(posts)")
                } catch {
                    result.error = NSError()
                }
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }
    
}
