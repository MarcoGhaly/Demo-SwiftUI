import Foundation
import Combine

protocol ToDosUseCasesProtocol: DemoUseCases {
    func getToDos(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[ToDo], AppError>
    func add(toDo: ToDo) -> AnyPublisher<ToDo, AppError>
    func delete(toDos: [ToDo]) -> AnyPublisher<Void, AppError>
}
