//
//  LCEViewModelTests.swift
//  DemoTests
//
//  Created by Marco Ghaly on 27/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import XCTest
import Combine
@testable import Demo

private let testLoadingViewModel = LoadingViewModel(style: .dialog, title: "Test Loading Title", message: "Test Loading Message")
private let testErrorViewModel = ErrorViewModel(image: (type: .system, name: "Test Error Image", mode: .icon), title: "Test Error Title", message: "Test Error Message", retry: (label: "Test Error Retry", action: {}))

class LCEViewModelTests: XCTestCase {
    var subscriptions: [AnyCancellable] = []
    
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
    
    private func testViewStates(model: TestModel? = nil, error: DefaultAppError? = nil) {
        let viewModel = LCEViewModelTest(model: model, error: error)
        
        if model != nil {
            guard case .content = viewModel.viewState else {
                XCTAssert(false)
                return
            }
            return
        }
        
        if case .loading(let loadingViewModel) = viewModel.viewState {
            validate(loadingViewModel: loadingViewModel)
        } else {
            XCTAssert(false)
            return
        }
        
        let expectation = self.expectation(description: "Data Callback")
        expectation.expectedFulfillmentCount = error == nil ? 2 : 1
        
        viewModel.objectWillChange.sink {
            expectation.fulfill()
        }
        .store(in: &subscriptions)
        
        waitForExpectations(timeout: 1)
        
        if error == nil {
            XCTAssertNotNil(viewModel.model)
        }
        
        if error != nil {
            if case .error(let errorViewModel) = viewModel.viewState {
                validate(errorViewModel: errorViewModel)
            } else {
                XCTAssert(false)
            }
        } else {
            guard case .content = viewModel.viewState else {
                XCTAssert(false)
                return
            }
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

private class LCEViewModelTest: LCEViewModel<TestModel> {
    let error: DefaultAppError?
    
    init(model: TestModel?, error: DefaultAppError? = nil) {
        self.error = error
        super.init(model: model)
    }
    
    override func dataPublisher() -> AnyPublisher<TestModel, DefaultAppError> {
        let publisher = PassthroughSubject<TestModel, DefaultAppError>()
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
