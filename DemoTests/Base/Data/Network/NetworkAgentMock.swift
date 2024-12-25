import Foundation
import Combine
@testable import Demo

final class NetworkAgentMock: NetworkAgentProtocol {
    var baseURL = ""
    
    var stubbedDataModel: Decodable = ""
    var stubbedCompletion: Subscribers.Completion<APIError<ErrorModelMock>> = .finished
    private(set) var performRequestCallCount = 0
    func performRequest<DataModel, ErrorModel>(_ request: Request) -> AnyPublisher<DataModel, APIError<ErrorModel>>
    where DataModel : Decodable, ErrorModel : Decodable {
        guard let stubbedDataModel = stubbedDataModel as? DataModel,
              let stubbedCompletion = stubbedCompletion as? Subscribers.Completion<APIError<ErrorModel>>
        else { fatalError() }
        
        performRequestCallCount += 1
        
        let publisher = PassthroughSubject<DataModel, APIError<ErrorModel>>()
        publisher.send(stubbedDataModel)
        publisher.send(completion: stubbedCompletion)
        return publisher.eraseToAnyPublisher()
    }
}

// MARK: - Error Model Mock
extension NetworkAgentMock {
    struct ErrorModelMock: Decodable {
        let code: Int
        let message: String
    }
}
