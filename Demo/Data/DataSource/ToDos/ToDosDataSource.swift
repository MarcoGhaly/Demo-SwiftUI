import Foundation
import Combine

protocol ToDosDataSource: DemoDataSource {
    func getRemoteToDos(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[ToDo], DefaultAPIError>
    func getLocalToDos(userID: Int?) -> AnyPublisher<[ToDo], DefaultAPIError>
}
