import Foundation
import Combine

protocol ToDosDataSource: DemoDataSource {
    func getRemoteToDos(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[ToDo], DataError>
    func getLocalToDos(userID: Int?) -> AnyPublisher<[ToDo], DataError>
}
