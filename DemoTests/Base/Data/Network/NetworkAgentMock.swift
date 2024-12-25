import Foundation
import Combine
import RealmSwift
@testable import Demo

final class NetworkAgentMock: NetworkAgentProtocol {
    var baseURL = ""
    
    var stubbedDataModel = [DataModelMock()]
    var stubbedCompletion: Subscribers.Completion<APIError<String>> = .finished
    private(set) var performRequestCalls = [Request]()
    func performRequest<DataModel, ErrorModel>(_ request: Request) -> AnyPublisher<DataModel, APIError<ErrorModel>>
    where DataModel : Decodable, ErrorModel : Decodable {
        guard let stubbedDataModel = stubbedDataModel as? DataModel,
              let stubbedCompletion = stubbedCompletion as? Subscribers.Completion<APIError<ErrorModel>>
        else { fatalError() }
        
        performRequestCalls.append(request)
        
        let publisher = PassthroughSubject<DataModel, APIError<ErrorModel>>()
        publisher.send(stubbedDataModel)
        publisher.send(completion: stubbedCompletion)
        return publisher.eraseToAnyPublisher()
    }
}

@objcMembers
class DataModelMock: Object, Decodable {
    dynamic var id: String
    override class func primaryKey() -> String? { "id" }
}
