//
//  BaseDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

protocol BaseDataSource {
    func performRequest<DataModel: Codable, ErrorModel: Codable>(withRelativeURL relativeURLString: String) -> AnyPublisher<DataModel, AppError<ErrorModel>>
    func performRequest<DataModel: Codable, ErrorModel: Codable>(withURL urlString: String) -> AnyPublisher<DataModel, AppError<ErrorModel>>
    func performRequest<DataModel: Codable>(urlString: String, completion: @escaping (Result<DataModel>) -> Void)
}

private extension BaseDataSource {
    private var baseURL: String { "https://jsonplaceholder.typicode.com/" }
    private var successCode: Int { 200 }
}

extension BaseDataSource {
    
    func performRequest<DataModel: Codable, ErrorModel: Codable>(withRelativeURL relativeURLString: String) -> AnyPublisher<DataModel, AppError<ErrorModel>> {
        let urlString = baseURL + relativeURLString
        return performRequest(withURL: urlString)
    }
    
    func performRequest<DataModel: Codable, ErrorModel: Codable>(withURL urlString: String) -> AnyPublisher<DataModel, AppError<ErrorModel>> {
        guard let url = URL(string: urlString) else {
            return Fail(error: .invalidURL(urlString: urlString)).eraseToAnyPublisher()
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, urlResponse in
                let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode
                if let statusCode = statusCode, statusCode == self.successCode {
                    return data
                }
                
                let errorModel = try jsonDecoder.decode(ErrorModel.self, from: data)
                throw AppError.statusCode(code: statusCode, errorModel: errorModel)
        }
        .decode(type: DataModel.self, decoder: jsonDecoder)
        .mapError { (error) -> AppError<ErrorModel> in
            (error as? AppError) ?? AppError.general(error: error)
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
}

extension BaseDataSource {
    
    func performRequest<DataModel: Codable>(urlString: String, completion: @escaping (Result<DataModel>) -> Void) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(Result(success: false, data: nil, error: NSError()))
            }
            return
        }
        
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print("\(#function) -> Response:\n\(response)")
            }
            
            var result = Result<DataModel>(success: false, data: nil, error: nil)
            
            if data == nil || error != nil {
                let error = error ?? NSError()
                result.error = error
            } else if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let posts = try jsonDecoder.decode(DataModel.self, from: data)
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

struct Result<Data> {
    var success: Bool
    var data: Data?
    var error: Error?
}
