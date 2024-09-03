import Foundation
import Combine
import RealmSwift
@testable import Demo

class DemoDataSourceMock: DemoDataSource {
    var methodName = ""
    var networkAgent: NetworkAgentProtocol = NetworkAgentMock()
    
    // MARK: - Remote
    
    var stubbedRemoteDataCompletion: Subscribers.Completion<DefaultAPIError> = .finished
    func getRemoteData<DataModel>(
        queryParameters: [String: String]?, page: Int?, limit: Int?
    ) -> AnyPublisher<[DataModel], DefaultAPIError>
    where DataModel: Object, DataModel: Decodable {
        let publisher = PassthroughSubject<[DataModel], DefaultAPIError>()
        DispatchQueue.main.async {
            publisher.send([])
            publisher.send(completion: self.stubbedRemoteDataCompletion)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    var stubbedAddRemoteID: Int?
    var stubbedAddRemoteCompletion: Subscribers.Completion<DefaultAPIError> = .finished
    func addRemote<DataModel>(object: DataModel) -> AnyPublisher<ID, DefaultAPIError>
    where DataModel: Object, DataModel: Encodable, DataModel: Identified {
        let publisher = PassthroughSubject<ID, DefaultAPIError>()
        DispatchQueue.main.async {
            publisher.send(.init(id: self.stubbedAddRemoteID))
            publisher.send(completion: self.stubbedAddRemoteCompletion)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    var stubbedDeleteRemoteCompletion: Subscribers.Completion<DefaultAPIError> = .finished
    func deleteRemote<DataModel>(object: DataModel) -> AnyPublisher<EmptyResponse, DefaultAPIError>
    where DataModel: Object, DataModel: Identified {
        let publisher = PassthroughSubject<EmptyResponse, DefaultAPIError>()
        DispatchQueue.main.async {
            publisher.send(.init())
            publisher.send(completion: self.stubbedDeleteRemoteCompletion)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    // MARK: - Local
    
    var stubbedLocalDataCompletion: Subscribers.Completion<DefaultAPIError> = .finished
    func getLocalData<DataModel>(
        queryParameters: [String: String]?, page: Int?, limit: Int?
    ) -> AnyPublisher<[DataModel], DefaultAPIError>
    where DataModel: Object, DataModel: Decodable {
        let publisher = PassthroughSubject<[DataModel], DefaultAPIError>()
        DispatchQueue.main.async {
            publisher.send([])
            publisher.send(completion: self.stubbedRemoteDataCompletion)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    func addLocal<DataModel>(object: DataModel) -> DataModel?
    where DataModel: Object, DataModel: Encodable, DataModel: Identified {
        object
    }
    
    func deleteLocal<DataModel>(object: DataModel) -> DataModel?
    where DataModel: Object, DataModel: Identified {
        object
    }
}
