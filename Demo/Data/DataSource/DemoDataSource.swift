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
        _ request: inout Request,
        page: Int?,
        limit: Int?
    ) -> AnyPublisher<DataModel, APIError<ErrorModel>>

    func getRemoteData<DataModel: Decodable & Object>(
        queryParameters: [String: String]?,
        page: Int?,
        limit: Int?
    ) -> AnyPublisher<[DataModel], DataError>
    
    func addRemote<DataModel: Encodable & Object & Identified>(
        object: DataModel
    ) -> AnyPublisher<ID, DataError>
    
    func deleteRemote<DataModel: Object & Identified>(
        object: DataModel
    ) -> AnyPublisher<EmptyResponse, DataError>
    
    // MARK: - Local
    
    func getLocalData<DataModel: Decodable & Object>(
        queryParameters: [String: String]?,
        page: Int?,
        limit: Int?
    ) throws(DataError) -> [DataModel]
    
    func addLocal<DataModel: Encodable & Object & Identified>(
        object: DataModel
    ) -> DataModel?
    
    func deleteLocal<DataModel: Object & Identified>(
        object: DataModel
    ) -> DataModel?
}

// MARK: - Remote
extension DemoDataSource {
    var queryParameters: [String: String]? { ["_limit": String(5)] }
    
    func performRequest<DataModel: Decodable, ErrorModel: Decodable>(
        _ request: inout Request,
        page: Int? = nil,
        limit: Int? = nil
    ) -> AnyPublisher<DataModel, APIError<ErrorModel>> {
        var queryParameters = request.queryParameters ?? [:]
        page.map { queryParameters["_page"] = String($0) }
        limit.map { queryParameters["_limit"] = String($0) }
        request.queryParameters = queryParameters
        return networkAgent.performRequest(request)
    }
    
    func getRemoteData<DataModel: Decodable & Object>(
        page: Int?,
        limit: Int?
    ) -> AnyPublisher<[DataModel], DataError> {
        getRemoteData(queryParameters: nil, page: page, limit: limit)
    }

    func getRemoteData<DataModel: Decodable & Object>(
        queryParameters: [String: String]? = nil,
        page: Int? = nil,
        limit: Int? = nil
    ) -> AnyPublisher<[DataModel], DataError> {
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
    
    func addRemote<DataModel: Encodable & Object & Identified>(
        object: DataModel
    ) -> AnyPublisher<ID, DataError> {
        let request = Request(url: methodName)
            .set(httpMethod: .POST)
            .set(body: object)
        return networkAgent.performRequest(request)
            .mapError { (error: DefaultAPIError) in
                .remoteError(error: error)
            }
            .eraseToAnyPublisher()
    }
    
    func deleteRemote<DataModel: Object & Identified>(
        object: DataModel
    ) -> AnyPublisher<EmptyResponse, DataError> {
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
    func getLocalData<DataModel: Decodable & Object>(
        queryParameters: [String: String]? = nil,
        page: Int? = nil,
        limit: Int? = nil
    ) throws(DataError) -> [DataModel] {
        do {
            var predicate: NSPredicate?
            if let format = queryParameters?.map({ "\($0)=\($1)" }).joined(separator: "&&"), !format.isEmpty {
                predicate = NSPredicate(format: format)
            }
            return try databaseManager.loadObjects(predicate: predicate)
        } catch(let error) {
            throw DataError.localError(error: error)
        }
    }
    
    func addLocal<DataModel: Encodable & Object & Identified>(
        object: DataModel
    ) -> DataModel? {
        try? databaseManager.save(object: object)
    }
    
    func deleteLocal<DataModel: Object & Identified>(
        object: DataModel
    ) -> DataModel? {
        let predicate = NSPredicate(format: "id = %@", argumentArray: [object.id])
        return try? databaseManager.deleteObjects(predicate: predicate).first
    }
}
