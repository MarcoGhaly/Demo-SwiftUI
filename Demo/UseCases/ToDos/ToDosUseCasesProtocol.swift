import Foundation
import Combine

protocol ToDosUseCasesProtocol: DemoUseCases {
    func getToDos(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[ToDo], DefaultAPIError>
    func add(toDo: ToDo) -> AnyPublisher<ToDo, DefaultAPIError>
    func delete(toDos: [ToDo]) -> AnyPublisher<Void, DefaultAPIError>
}
