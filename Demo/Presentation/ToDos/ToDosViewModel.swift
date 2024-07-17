import Foundation
import Combine

class ToDosViewModel<UseCases: ToDosUseCases>: BaseLCEListViewModel<ToDo, UseCases> {
    let userID: Int?
    
    init(useCases: UseCases = ToDosUseCases(), userID: Int? = nil, todos: [ToDo]? = nil) {
        self.userID = userID
        super.init(useCases: useCases, models: todos, limit: 20)
        setActions()
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[ToDo], DefaultAPIError> {
        useCases.getToDos(userID: userID, page: page, limit: limit)
    }
    
    func add(toDo: ToDo) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        useCases.add(toDo: toDo).sink { [weak self] completion in
            self?.updateViewState(completion: completion)
        } receiveValue: { [weak self] toDo in
            self?.model?.insert(toDo, at: 0)
        }
        .store(in: &subscriptions)
    }
    
    private func deleteToDos(withIDs ids: Set<Int>) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        let toDos = ids.compactMap { toDoID in
            model?.first { $0.id == toDoID }
        }
        
        useCases.delete(toDos: toDos).sink { [weak self] completion in
            self?.updateViewState(completion: completion)
        } receiveValue: { [weak self] _ in
            self?.model?.removeAll { ids.contains($0.id) }
        }
        .store(in: &subscriptions)
    }
    
    private func setActions() {
        actionPublisher.sink { [weak self] action in
            switch action {
            case .add:
                break
            case .delete(let IDs):
                self?.deleteToDos(withIDs: IDs)
            }
        }.store(in: &subscriptions)
    }
}
