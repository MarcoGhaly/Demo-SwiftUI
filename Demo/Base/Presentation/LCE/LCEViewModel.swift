import Foundation
import Combine

class LCEViewModel<Model>: ObservableObject {
    // MARK: - Constants
    
    enum ViewState {
        case content
        case loading(model: LoadingViewModel)
        case error(model: ErrorViewModel)
    }
    
    // MARK: - Variables
    
    var subscriptions: [AnyCancellable] = []
    @Published var viewState = ViewState.content
    @Published var model: Model?
    
    // MARK: - Initializers
    
    init(model: Model? = nil) {
        if let model = model {
            self.model = model
        } else {
            fetchData()
        }
    }
    
    // MARK: - Loading & Error
    
    func loadingViewModel() -> LoadingViewModel {
        LoadingViewModel(style: .normal, title: "Loading...", message: "Please Wait")
    }
    
    func errorViewModel(fromError error: Error) -> ErrorViewModel {
        ErrorViewModel(title: "Error!", message: error.localizedDescription, retry: (label: "Retry", action: { self.fetchData() }))
    }
    
    // MARK: - Fetch Data
    
    func dataPublisher() -> AnyPublisher<Model, DefaultAPIError> {
        fatalError("Subclass must implement this publisher")
    }
    
    func fetchData() {
        viewState = .loading(model: loadingViewModel())
        
        dataPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.updateViewState(completion: completion)
            } receiveValue: { [weak self] (model) in
                self?.model = model
            }
            .store(in: &subscriptions)
    }
    
    func updateViewState(completion: Subscribers.Completion<DefaultAPIError>) {
        switch completion {
        case .finished:
            viewState = .content
        case .failure(let error):
            viewState = .error(model: errorViewModel(fromError: error))
        }
    }
}
