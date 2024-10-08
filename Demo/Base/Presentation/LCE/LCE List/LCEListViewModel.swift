import Foundation
import Combine

class LCEListViewModel<Element, AppError>: LCEViewModel<[Element], AppError> where AppError: Error {
    private var limit: Int?
    private var page = 1
    
    @Published var isLoading = false
    
    init(models: [Element]? = nil, limit: Int? = nil) {
        self.limit = limit
        super.init(model: models)
        
        if let limit = self.limit {
            $model.compactMap { $0 }.sink { [weak self] model in
                let oldCount = self?.model?.count ?? 0
                let newCount = model.count
                if newCount - oldCount < limit {
                    self?.limit = nil
                    if newCount == 0, case .content = self?.viewState, let errorViewModel = self?.emptyModelErrorViewModel() {
                        self?.viewState = .error(model: errorViewModel)
                    }
                }
            }.store(in: &subscriptions)
        }
    }
    
    func emptyModelErrorViewModel() -> ErrorViewModel {
        ErrorViewModel(title: "No Data Found")
    }
    
    override func dataPublisher() -> AnyPublisher<[Element], AppError> {
        dataPublisher(page: page, limit: limit)
    }
    
    func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[Element], AppError> {
        fatalError("Subclass must implement this publisher")
    }
    
    override func updateViewState(completion: Subscribers.Completion<AppError>) {
        if case .finished = completion, model?.isEmpty == true {
            viewState = .error(model: emptyModelErrorViewModel())
        } else {
            super.updateViewState(completion: completion)
        }
    }
    
    private func fetchMoreData() {
        dataPublisher().sink { [weak self] completion in
            self?.isLoading = false
        } receiveValue: { [weak self] model in
            self?.model?.append(contentsOf: model)
        }
        .store(in: &subscriptions)
    }
    
    func scrolledToEnd() {
        if !isLoading && limit != nil {
            isLoading = true
            page += 1
            fetchMoreData()
            // TODO: Calling "objectWillChange" manually because it's not called after "isLoading" is updated (remove after fix)
            objectWillChange.send()
        }
    }
}
