import XCTest
import Combine
@testable import Demo

let testLoadingViewModel = LoadingViewModel(style: .dialog, title: "Test Loading Title", message: "Test Loading Message")
let testErrorViewModel = ErrorViewModel(image: (type: .system, name: "Test Error Image", mode: .icon), title: "Test Error Title", message: "Test Error Message", retry: (label: "Test Error Retry", action: {}))

class LCEViewModelTests: XCTestCase {
    func testContentViewState() {
        testViewStates(model: TestModel())
    }
    
    func testLoadingContentViewState() {
        testViewStates()
    }
    
    func testLoadingErrorViewState() {
        let error = NSError(domain: "Test Domain", code: 1)
        testViewStates(error: .general(error: error))
    }
    
    private func testViewStates(model: TestModel? = nil, error: AppError? = nil) {
        let viewModel = LCEViewModelTest(model: model, error: error)
        testViewStates(viewModel: viewModel, error: error)
    }
    
    func testViewStates<T>(viewModel: LCEViewModel<T, AppError>, error: AppError? = nil) {
        if viewModel.model != nil {
            guard case .content = viewModel.viewState else {
                XCTAssert(false)
                return
            }
            return
        }
        
        validateLoading(viewModel: viewModel)
        
        let expectation = self.expectation(description: "Data Callback")
        expectation.expectedFulfillmentCount = error == nil ? 2 : 1
        let cancellable = viewModel.objectWillChange.sink {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        cancellable.cancel()
        
        if error != nil {
            validateError(viewModel: viewModel)
        } else {
            validateContent(viewModel: viewModel)
            XCTAssertNotNil(viewModel.model)
        }
    }
    
    func validateContent<T>(viewModel: LCEViewModel<T, AppError>) {
        guard case .content = viewModel.viewState else {
            XCTAssert(false)
            return
        }
    }
    
    func validateLoading<T>(viewModel: LCEViewModel<T, AppError>) {
        if case .loading(let loadingViewModel) = viewModel.viewState {
//            validate(loadingViewModel: loadingViewModel)
        } else {
            XCTAssert(false)
            return
        }
    }
    
    func validateError<T>(viewModel: LCEViewModel<T, AppError>) {
        if case .error(let errorViewModel) = viewModel.viewState {
//            validate(errorViewModel: errorViewModel)
        } else {
            XCTAssert(false)
        }
    }
    
    private func validate(loadingViewModel: LoadingViewModel) {
        XCTAssertEqual(loadingViewModel.style, .dialog)
        XCTAssertEqual(loadingViewModel.title, "Test Loading Title")
        XCTAssertEqual(loadingViewModel.message, "Test Loading Message")
    }
    
    private func validate(errorViewModel: ErrorViewModel) {
        XCTAssertEqual(errorViewModel.title, "Test Error Title")
        XCTAssertEqual(errorViewModel.message, "Test Error Message")
        XCTAssertEqual(errorViewModel.image?.type, .system)
        XCTAssertEqual(errorViewModel.image?.name, "Test Error Image")
        XCTAssertEqual(errorViewModel.image?.mode, .icon)
        XCTAssertEqual(errorViewModel.retry?.label, "Test Error Retry")
    }
}

private class LCEViewModelTest: LCEViewModel<TestModel, AppError> {
    private let error: AppError?
    
    init(model: TestModel?, error: AppError? = nil) {
        self.error = error
        super.init(model: model)
    }
    
    override func dataPublisher() -> AnyPublisher<TestModel, AppError> {
        let publisher = PassthroughSubject<TestModel, AppError>()
        DispatchQueue.main.async {
            if let error = self.error {
                publisher.send(completion: .failure(error))
            } else {
                publisher.send(TestModel(number: 0, text: ""))
                publisher.send(completion: .finished)
            }
        }
        return publisher.eraseToAnyPublisher()
    }
    
    override func loadingViewModel() -> LoadingViewModel { testLoadingViewModel }
    
    override func errorViewModel(fromError error: Error) -> ErrorViewModel { testErrorViewModel }
}
