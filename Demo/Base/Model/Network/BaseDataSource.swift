//
//  BaseDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

struct EmptyResponse: Decodable {}

protocol BaseDataSource {
    var baseURL: String { get }
    var timeoutInterval: TimeInterval { get }
    var headers: [String: String]? { get }
    var pathParameters: [String]? { get }
    var queryParameters: [String: String]? { get }
    
    func performRequest<DataModel: Decodable, ErrorModel: Decodable>(_ request: Request) -> AnyPublisher<DataModel, AppError<ErrorModel>>
    func performRequest<DataModel: Decodable>(urlString: String, completion: @escaping (Result<DataModel>) -> Void)
}

extension BaseDataSource {
    var timeoutInterval: TimeInterval { 30 }
    var headers: [String: String]? { return nil }
    var pathParameters: [String]? { return nil }
    var queryParameters: [String: String]? { return nil }
}

extension BaseDataSource {
    private var successCode: Range<Int> { 200..<300 }
    
    func performRequest<DataModel: Decodable, ErrorModel: Decodable>(_ request: Request) -> AnyPublisher<DataModel, AppError<ErrorModel>> {
        if let headers = self.headers {
            request.headers?.merge(headers) { (current, _) in current }
        }
        if let pathParameters = self.pathParameters {
            request.pathParameters?.insert(contentsOf: pathParameters, at: 0)
        }
        if let queryParameters = self.queryParameters {
            request.queryParameters?.merge(queryParameters) { (current, _) in current }
        }
        
        let urlString = baseURL + request.formattedURL
        guard let url = URL(string: urlString) else {
            return Fail(error: .invalidURL(urlString: urlString)).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.timeoutInterval = request.timeoutInterval ?? timeoutInterval
        
        request.headers?.forEach({ key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        })
        
        urlRequest.httpBody = request.body
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = request.datesType.decodingStrategy
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, urlResponse in
                let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode
                if let statusCode = statusCode, self.successCode ~= statusCode {
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
    func performRequest<DataModel: Decodable>(urlString: String, completion: @escaping (Result<DataModel>) -> Void) {
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
