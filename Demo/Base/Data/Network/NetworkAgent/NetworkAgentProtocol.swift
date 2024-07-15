//
//  NetworkAgentProtocol.swift
//  Authentication
//
//  Created by Marco Ghaly on 01/03/2021.
//

import Foundation
import Combine

struct EmptyResponse: Decodable {}

protocol NetworkAgentProtocol {
    var baseURL: String { get }
    var timeoutInterval: TimeInterval { get }
    var headers: [String: String]? { get }
    var pathParameters: [String]? { get }
    var queryParameters: [String: String]? { get }
    
    func performRequest<DataModel: Decodable, ErrorModel: Decodable>(_ request: Request) -> AnyPublisher<DataModel, APIError<ErrorModel>>
}

extension NetworkAgentProtocol {
    var timeoutInterval: TimeInterval { 30 }
    var headers: [String: String]? { return nil }
    var pathParameters: [String]? { return nil }
    var queryParameters: [String: String]? { return nil }
}

extension NetworkAgentProtocol {
    private var successCodes: Range<Int> { 200..<300 }
    
    func performRequest<DataModel, ErrorModel>(_ request: Request) -> AnyPublisher<DataModel, APIError<ErrorModel>> where DataModel: Decodable {
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
            return Fail(error: .invalidURL).eraseToAnyPublisher()
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
        
        return performRequest(urlRequest, decoder: jsonDecoder, retries: request.retries)
    }
    
    private func performRequest<DataModel, ErrorModel, Decoder>(_ request: URLRequest, decoder: Decoder, retries: Retries? = nil) -> AnyPublisher<DataModel, APIError<ErrorModel>> where DataModel: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data {
        let urlSession = URLSession(configuration: .default)
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { data, urlResponse in
                guard let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode else {
                    throw APIError<ErrorModel>.unknownError
                }
                
                if self.successCodes ~= statusCode {
                    if let emptyRespone = EmptyResponse() as? DataModel {
                        return emptyRespone
                    } else {
                        do {
                            return try decoder.decode(DataModel.self, from: data)
                        } catch {
                            let rawResponse = String(data: data, encoding: .utf8)
                            throw APIError<ErrorModel>.decoding(rawResponse: rawResponse)
                        }
                    }
                }
                
                let errorModel = try? decoder.decode(ErrorModel.self, from: data)
                throw APIError.statusCode(code: statusCode, errorModel: errorModel)
            }
            .mapError { error -> APIError<ErrorModel> in
                map(error: error)
            }
            .catch { error -> AnyPublisher<DataModel, APIError<ErrorModel>> in
                var publisher = Fail(outputType: DataModel.self, failure: error).eraseToAnyPublisher()
                if let retries = retries, shouldDelay(error: error, retries: retries) {
                    publisher = publisher.delay(for: .seconds(retries.nextDelay), scheduler: DispatchQueue.main).eraseToAnyPublisher()
                }
                return publisher
            }
            .catch { error -> AnyPublisher<DataModel, APIError<ErrorModel>> in
                if let retries = retries, shouldRetry(error: error, retries: retries) {
                    return performRequest(request, decoder: decoder, retries: retries.retry())
                }
                return Fail(outputType: DataModel.self, failure: error).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func map<ErrorModel>(error: Error) -> APIError<ErrorModel> {
        switch error {
        case URLError.Code.badURL, URLError.Code.unsupportedURL:
            return .invalidURL
        case URLError.notConnectedToInternet,
             URLError.networkConnectionLost,
             URLError.cannotLoadFromNetwork:
            return .noInternet
        case URLError.Code.timedOut:
            return .timeout
        default:
            return (error as? APIError) ?? .general(error: error)
        }
    }
    
    private func shouldDelay<ErrorModel>(error: APIError<ErrorModel>, retries: Retries) -> Bool {
        if case .noInternet = error {
            return false
        }
        return retries.shouldDelay
    }
    
    private func shouldRetry<ErrorModel>(error: APIError<ErrorModel>, retries: Retries) -> Bool {
        if case .noInternet = error {
            return false
        }
        return retries.canRetry
    }
}
