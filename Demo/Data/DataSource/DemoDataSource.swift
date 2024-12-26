import Foundation
import Combine
import RealmSwift

protocol DemoDataSource {
    var methodName: String { get }
    var queryParameters: [String: String]? { get }
    
    var networkAgent: NetworkAgentProtocol { get }
    var databaseManager: DatabaseManagerProtocol { get }
    
    // MARK: - Remote
    
    func performRequest<DataModel: Decodable, ErrorModel: Decodable>(
        _ request: inout Request, page: Int?, limit: Int?
    ) -> AnyPublisher<DataModel, APIError<ErrorModel>>

    func getRemoteData<DataModel>(
        queryParameters: [String: String]?, page: Int?, limit: Int?
    ) -> AnyPublisher<[DataModel], DataError>
    where DataModel: Object, DataModel: Decodable
    
    func addRemote<DataModel>(object: DataModel) -> AnyPublisher<ID, DataError>
    where DataModel: Object, DataModel: Encodable, DataModel: Identified
    
    func deleteRemote<DataModel>(object: DataModel) -> AnyPublisher<EmptyResponse, DataError>
    where DataModel: Object, DataModel: Identified
    
    // MARK: - Local
    
    func getLocalData<DataModel>(
        queryParameters: [String: String]?, page: Int?, limit: Int?
    ) -> AnyPublisher<[DataModel], DataError>
    where DataModel: Object, DataModel: Decodable
    
    func addLocal<DataModel>(object: DataModel) -> DataModel?
    where DataModel: Object, DataModel: Encodable, DataModel: Identified
    
    func deleteLocal<DataModel>(object: DataModel) -> DataModel?
    where DataModel: Object, DataModel: Identified
}

// MARK: - Remote
extension DemoDataSource {
    var queryParameters: [String: String]? { ["_limit": String(5)] }
    
    func performRequest<DataModel: Decodable, ErrorModel: Decodable>(
        _ request: inout Request, page: Int? = nil, limit: Int? = nil
    ) -> AnyPublisher<DataModel, APIError<ErrorModel>> {
        var queryParameters = request.queryParameters ?? [:]
        page.map { queryParameters["_page"] = String($0) }
        limit.map { queryParameters["_limit"] = String($0) }
        request.queryParameters = queryParameters
        return networkAgent.performRequest(request)
    }
    
    func getRemoteData<DataModel>(page: Int?, limit: Int?) -> AnyPublisher<[DataModel], DataError>
    where DataModel: Object, DataModel: Decodable {
        getRemoteData(queryParameters: nil, page: page, limit: limit)
    }

    func getRemoteData<DataModel>(
        queryParameters: [String: String]? = nil, page: Int? = nil, limit: Int? = nil
    ) -> AnyPublisher<[DataModel], DataError>
    where DataModel: Object, DataModel: Decodable {
        var parameters = queryParameters ?? [:]
        self.queryParameters.map { parameters.merge($0) { (current, _) in current } }
        
        var request = Request(url: methodName)
            .set(queryParameters: parameters)
        
        return performRequest(&request, page: page, limit: limit)
            .mapError { (error: DefaultAPIError) in
                .remoteError(error: error)
            }
            .eraseToAnyPublisher()
    }
    
    func addRemote<DataModel>(object: DataModel) -> AnyPublisher<ID, DataError>
    where DataModel: Object, DataModel: Encodable, DataModel: Identified {
        let request = Request(url: methodName)
            .set(httpMethod: .POST)
            .set(body: object)
        return networkAgent.performRequest(request)
            .mapError { (error: DefaultAPIError) in
                .remoteError(error: error)
            }
            .eraseToAnyPublisher()
    }
    
    func deleteRemote<DataModel>(object: DataModel) -> AnyPublisher<EmptyResponse, DataError>
    where DataModel: Object, DataModel: Identified {
        let request = Request(url: methodName)
            .set(httpMethod: .DELETE)
            .set(pathParameters: [String(object.id)])
        return networkAgent.performRequest(request)
            .mapError { (error: DefaultAPIError) in
                .remoteError(error: error)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Local
extension DemoDataSource {
    func getLocalData<DataModel>(
        queryParameters: [String: String]? = nil, page: Int? = nil, limit: Int? = nil
    ) -> AnyPublisher<[DataModel], DataError> where DataModel: Object, DataModel: Decodable {
        var predicate: NSPredicate?
        if let format = queryParameters?.map({ "\($0)=\($1)" }).joined(separator: "&&"), !format.isEmpty {
            predicate = NSPredicate(format: format)
        }
        return databaseManager.loadObjects(predicate: predicate)
            .mapError { .localError(error: $0) }
            .eraseToAnyPublisher()
    }
    
    func addLocal<DataModel>(object: DataModel) -> DataModel?
    where DataModel: Object, DataModel: Encodable, DataModel: Identified {
        try? databaseManager.save(object: object)
    }
    
    func deleteLocal<DataModel>(object: DataModel) -> DataModel?
    where DataModel: Object, DataModel: Identified {
        let predicate = NSPredicate(format: "id = %@", argumentArray: [object.id])
        return try? databaseManager.deleteObjects(predicate: predicate).first
    }
}
